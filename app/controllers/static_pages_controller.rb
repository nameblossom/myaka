require 'bcrypt'
require 'securerandom'

class StaticPagesController < ApplicationController
  def home
    @aka = Aka.new
  end

  def login_help
  end

  def send_login_help_email
    if params[:aka_lookup]
      AccountHelper.forgot_akas(params[:aka_lookup][:email]).deliver
      flash[:success] = "Mail sent from #{Myaka::Application.config.support_mail_from}. Be sure to check your spam folder."
    elsif params[:password_reset]
      aka = Aka.find_by_subdomain(params[:password_reset][:subdomain])
      if aka.nil?
        flash[:error] = "That aka doesn't exist."
      elsif aka.email.blank?
        flash[:error] = "That AKA doesn't have an e-mail address associated with it. Sorry."
      else
        key = SecureRandom.base64(32).gsub('=','').gsub('+','-').gsub('/','_')
        reset = aka.password_resets.build(expiration: 2.days.from_now, key: BCrypt::Password.create(key))
        reset.save
        AccountHelper.forgot_password(reset, key).deliver
        flash[:success] = "Password reset e-mail sent from #{Myaka::Application.config.support_mail_from}. Be sure to check your spam folder."
      end
    end
    redirect_to '/loginhelp'  
  end

  def finish_reset
    @id = params[:reset][:id]
    @key = params[:reset][:key]
    @reset = get_reset(@id,@key)
    if @reset.nil?
      flash[:error] = "The password code is invalid. It may be expired."
      render 'begin_reset'
      return
    end
    if params[:reset][:password].blank?
      flash[:error] = "Password is required."
      render 'begin_reset'
      return
    end
    if params[:reset][:password] != params[:reset][:confirm_password]
      flash[:error] = "The passwords don't match"
      render 'begin_reset'
      return
    end
    ok = @reset.aka.update_attributes({ password: params[:reset][:password], password_confirmation: params[:reset][:confirm_password] })
    if not ok
      flash[:error] = "The password reset didn't work. Do your passwords match?"
      render 'begin_reset'
      return
    else
      @reset.delete
      flash[:success] = "Password changed."
      redirect_to root_path
    end
  end

  def begin_reset
    @id = params[:id]
    @key = params[:key]
    @reset = get_reset(@id,@key)
  end

  def get_reset(id, key)
    reset = PasswordReset.find_by_id(@id)
    unless reset and BCrypt::Password.new(reset.key) == @key and Time.now < reset.expiration
      return nil
    end
    return reset
  end

  def privacy
  end

end
