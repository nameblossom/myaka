require 'json'

class IoController < ApplicationController
  include AkasHelper

  def import
    if params[:confirmed]
      do_import JSON.parse(params[:import_data])
      flash[:success] = 'Imported data'
      redirect_to root_path
    else
      @import_data = params[:import_file].read
      @import = JSON.parse(@import_data)
    end
  end

  def export
    response = {
      :version => 1,
      :aka => current_aka.domain_name,
      :tent_server => current_aka.tent_server,
      :profile_links => current_aka.profile_links.map {|link|
        {
          :id => link.external_id,
          :href => link.href,
          :title => link.title,
          :rel => link.rel,
          :autofollow => link.autofollow
        }
      },
      :profile_template => current_aka.profile.profile_source
    }
    headers['Content-Disposition'] = "attachment; filename=#{current_aka.domain_name}.aka"
    render formats:'json', json:response
  end

  def do_import data
    Aka.transaction do
      current_aka.profile_links.clear
      data['profile_links'].each do |link|
        profile_link = current_aka.profile_links.build(href:link['href'],
                                                       autofollow:link['autofollow'],
                                                       title:link['title'])
        profile_link.rel = link['rel']
        profile_link.external_id = link['id']
        profile_link.save!
      end
      current_aka.profile.profile_source = data['profile_template']
      current_aka.tent_server = data['tent_server']
      current_aka.save!
    end
  end
  
end
