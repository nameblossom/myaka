require 'digest/sha2'
require 'json'
require 'builder'

class PublicResource < ActiveRecord::Base
  include AkasHelper

  #attr_accessible :content, :etag, :headers, :path
  validates_presence_of :content, :etag, :content_type
  validates :path, uniqueness: { :scope => :aka_id }
  belongs_to :aka

  def save_host_meta!
    b = ::Builder::XmlMarkup.new
    doc = b.XRD(:xmlns => 'http://docs.oasis-open.org/ns/xri/xrd-1.0',
                :"xmlns:xsi" => 'http://www.w3.org/2001/XMLSchema-instance',
                :"xmlns:aka" => 'http://aka.nu/XRD') do |xrd|
      xrd.Subject "dns:#{self.aka.domain_name}"
      xrd.Title aka.display_or_subdomain_name
      self.aka.profile_links.each do |link|
        xrd.Link rel: link.rel, href: link.href, "aka:id" => link.external_id do |tag|
          tag.Title link.title
          if link.autofollow
            tag.Property :type => 'http://aka.nu/Autofollow', "xsi:nil" => "true"
          end
        end
      end
    end
    self.update!(doc.to_s.encode('utf-8'), 'application/xrd+xml')
  end

  def save_host_meta_json!
    links = self.aka.profile_links.map {|link|
      properties = { }
      if link.autofollow
        properties[:'http://aka.nu/Autofollow'] = nil
      end
      {
        :id => link.external_id,
        :rel => link.rel,
        :href => link.href,
        :titles => { :default => link.title },
        :properties => properties
      }
    }
    host_meta_data = {
      "subject" => "dns:#{self.aka.domain_name}",
      "title" => self.aka.display_or_subdomain_name,
      "links" => links
    }
    self.update!(JSON.dump(host_meta_data),'application/json')
  end

  def save_home_page!
    headers = nil
    if self.aka.tent_server
      headers = "Link:<" + self.aka.tent_server + '>; rel="https://tent.io/rels/profile"'
    end
    self.update!(render_profile(self.aka), 'text/html; charset=utf-8', headers)
  end

  def update!(content, content_type, headers = nil)
    self.content_type = content_type
    self.content = content
    self.headers = headers
    digest = Digest::SHA256.new
    digest << content_type
    digest << "\n"
    digest << (headers ? headers : '')
    digest << "\n\n"
    digest << content
    self.etag = digest.to_s
    self.save!
  end
  
end
