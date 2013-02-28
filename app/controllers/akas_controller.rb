class AkasController < ApplicationController
  include AkasHelper

  def new
    @aka = Aka.new
  end

  def create
    @aka = Aka.new(params[:aka])
    @aka.subdomain = params[:subdomain]
    if @aka.save
      sign_in @aka
      flash[:success] = "Welcome to your new AKA, #{@aka.display_or_domain_name}!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def update_current
    @errors = []
    if params[:current_aka] and (params[:current_aka][:email] or params[:current_aka][:password])
      unless current_aka.authenticate(params[:current_password])
        @errors.append('Current password is not valid')
        @saved = false
      end
    end
    if @errors.empty?
      @saved = current_aka.update_attributes(params[:current_aka])
      unless @saved
        @errors += current_aka.errors.full_messages
      end
    end
    @form_name = params[:form_name]
    respond_to do |format|
      format.html {
        if @saved
          flash[:success] = "Changes saved."
          redirect_to request.referrer || root_path
        else
          flash[:error] = "There were some errors.\n" + @errors.map{|e|'* '+e}.join('\n')
          redirect_to request.referrer || root_path
        end
      }
      format.js
    end
  end

  def profile_editor
    if not current_aka
      flash[:error] = 'You need to log in for that.'
      redirect_to root_path
    end
  end

  def preview_profile
    render text: render_profile(current_aka, params[:template])
  end

  def edit_profile
    if params[:preview]
      render text: render_profile(current_aka, params[:profile][:profile_source])
      return
    end
    saved = current_aka.profile.update_attributes(params[:profile])
    if saved
      flash[:success] = 'Profile saved'
      redirect_to root_path
    else
      @error = 'Something went wrong. Sorry.'
      render 'profile_editor'
    end
  end

  def remove_trust_root
    @trust_root = current_aka.openid_trust_roots.find(params[:id])
    if @trust_root
      @trust_root.delete
    end
  end
end
