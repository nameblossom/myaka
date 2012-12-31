class SessionsController < ApplicationController

  def new
  end

  def create
    @aka_subdomain = params[:session][:aka].downcase
    aka = Aka.find_by_subdomain(@aka_subdomain)
    if aka && aka.authenticate(params[:session][:password])
      sign_in aka
      redirect_to root_path
    else
      flash[:error] = 'Invalid aka/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    flash[:success] = 'Signed out'
    redirect_to root_path
  end

end
