require 'mustache'

class ProfileController < ActionController::Base
  before_filter :get_aka, :add_cors_header
  include AkasHelper

  def home
    unless @aka
      render 'no_such_aka', status: 404
      return
    end
    unless @aka.tent_server.blank?
      response.headers['Link'] = "<#{@aka.tent_server.sub(/\/\Z/,'')}/profile>; rel=\"https://tent.io/rels/profile\""
    end
    respond_to do |format|
      format.html { render text: self.render_profile(@aka) }
      format.xrds
    end
  end

  def host_meta
    respond_to do |format|
      format.xrd { render :formats => :xml, content_type: 'application/xrd+xml' }
      format.xml
      format.json
    end
  end
  
  def add_cors_header
    response.headers['Access-Control-Allow-Origin'] = '*'
  end

  def get_aka
    if request.headers['Host'] != Myaka::Application.config.backend_domain
      subdomain = request.headers['Host'].sub(/\.#{Regexp.escape(Myaka::Application.config.aka_domain)}\Z/,'')
      @aka = Aka.find_by_subdomain subdomain
    else
      @aka = Aka.find_by_subdomain(params[:subdomain])
      raise ActionController::RoutingError.new('Not Found') unless @aka
    end
  end

  def preview
    render text: render_profile(Aka.find_by_subdomain(params[:subdomain]), params[:template])
  end

end
