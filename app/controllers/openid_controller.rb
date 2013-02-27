require 'pathname'

require "openid"
require "openid/consumer/discovery"
require 'openid/extensions/sreg'
require 'openid/extensions/pape'
require 'openid_ar_store'

class OpenidController < ApplicationController
  include OpenID::Server
  include AkasHelper
  include SessionsHelper

  skip_before_filter :verify_authenticity_token, only: :main

  def server_url
    "https://#{Myaka::Application.config.myaka_domain}/openid"
  end

  def main
    @message = ''
    oidreq = nil
    begin
      oidreq = server.decode_request(params)
    rescue ProtocolError => e
      # invalid openid request, so just display a page with an error message
      @message = e.to_s
      render status: 500
      return
    end

    identity = nil

    if oidreq.kind_of?(CheckIDRequest)
      identity = oidreq.identity
      if oidreq.id_select
        if oidreq.immediate
          oidresp = oidreq.answer(false)
        elsif not signed_in?
          # The user hasn't logged in.
          show_decision_page(oidreq)
          return
        else
          # Else, set the identity to the one the user is using.
          identity = current_aka.url
        end
      end
    else
      oidresp = server.handle_request(oidreq)
    end
    
    if oidresp
      nil
    elsif self.is_authorized(identity, oidreq.trust_root)
      oidresp = oidreq.answer(true, nil, identity)
      # TODO sreg/pape
    elsif oidreq.immediate
      oidresp = oidreq.answer(false, server_url)
    else
      show_decision_page(oidreq)
      return
    end
    self.render_response(oidresp)
  end

  def is_authorized(identity, trust_root)
    if not signed_in?
      false
    elsif get_subdomain(identity).downcase != current_aka.subdomain
      false
    else
      current_aka.openid_trust_roots.find_by_trust_root(trust_root)
    end
  end

  def show_decision_page(oidreq)
    @target_domain = oidreq.return_to.sub(/\Ahttps?\:\/\//,'').sub(/\/.*\Z/,'')
    @oidreq = oidreq
    @cancel_url = oidreq.cancel_url
    @specified_subdomain = oidreq.identity ? get_subdomain(oidreq.identity) : nil
    if not oidreq.identity
      @correct_aka = false
    elsif not signed_in?
      @correct_aka = false
    else
      @correct_aka = get_subdomain(oidreq.identity).downcase == current_aka.subdomain
    end
    session[:last_oidreq] = oidreq
    render 'login'
  end

  def confirm
    oidreq = session[:last_oidreq]    
    if params[:answer][:password]
      @trust = params[:answer][:trust]
      @specified_subdomain = get_subdomain(oidreq.identity)
      @oidreq = oidreq
      @cancel_url = oidreq.cancel_url
      @correct_aka = signed_in? and @specified_subdomain.downcase == current_aka.subdomain
      unless @correct_aka
        aka = Aka.find_by_subdomain(get_subdomain(oidreq.identity))
        if aka and aka.authenticate(params[:answer][:password])
          sign_in(aka)
        else
          flash.now[:error] = "That password isn't right"
          render 'login'
          return
        end
      end
    end

    session[:last_oidreq] = nil
    oidresp = oidreq.answer(true, nil, current_aka.url)
    if params[:answer][:trust] == '1' and OpenidTrustRoot.where(aka_id: current_aka.id, trust_root: oidreq.trust_root).empty?
      current_aka.openid_trust_roots.build(trust_root: oidreq.trust_root).save
    end
    # todo sreg/pape
    return self.render_response(oidresp)
  end

  def server
    if @server.nil?
      store = ActiveRecordStore.new
      @server = Server.new(store, server_url)
    end
    return @server
  end

  def render_response(oidresp)
    if oidresp.needs_signing
      signed_response = server.signatory.sign(oidresp)
    end
    web_response = server.encode_response(oidresp)
    case web_response.code
    when HTTP_OK
      status = 200
    when HTTP_REDIRECT
      redirect_to web_response.headers['location']
      return
    else
      status = 400
    end
    render text: web_response.body, status: status, layout: nil,
      content_type: 'text/plain'
  end

end
