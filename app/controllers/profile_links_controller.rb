class ProfileLinksController < ApplicationController

  def index
    if params[:inline]
      render '_link_list', layout: nil
    end
  end

  def show
    @link = current_aka.profile_links.find(params[:id])
    if params[:inline]
      render '_create_form_fields', layout: nil
    end
  end

  def update
    @link = current_aka.profile_links.find(params[:id])
    @saved = @link.update_attributes(profile_link_attributes)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render 'create' }
    end
  end

  def new
    @link = ProfileLink.new
    if params[:inline]
      render '_create_form_fields', layout: nil
    end
  end

  def create
    @link = current_aka.profile_links.build(profile_link_attributes)
    @saved = @link.save
    respond_to do |format|
      format.js
      format.html { redirect_to root_path }
    end
  end

  def destroy
    @link = ProfileLink.find(params[:id])
    @deleted = false
    if current_aka == @link.aka
      @deleted = @link.destroy
    end
    respond_to do |format|
      format.js
    end
  end
  
  private
    def profile_link_attributes
      params[:profile_link].permit(:autofollow, :href, :title)
    end
end
