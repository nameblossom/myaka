class Aka < ActiveRecord::Base
  has_secure_password
  attr_accessible :display_name, :email, :password, :password_confirmation, :tent_server, :keep_me_updated
  validates(:subdomain,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: /\A(?!xn\-\-)[a-z0-9][a-z0-9\-]*\z/ },
            exclusion: { in: ['www','support','ftp','mail','system','help',
                              'sys','aka','ns','ns1','ns2','ns3','ns4',
                              'downloads','store','marketplace','apps',
                              'login','signin','openid','shop','dns','kb',
                              'admin','ssl','services','api','blog','news',
                              'git','code','security','bugs','wiki','profile-preview'] })

  has_many :profile_links
  has_many :openid_trust_roots
  has_one :profile_page
  has_many :password_resets
  has_many :public_resources

  after_save :update_resources

  def profile
    return self.profile_page || self.create_profile_page
  end

  def display_or_domain_name
    if self.display_name.blank?
      self.domain_name
    else
      self.display_name
    end
  end

  def display_or_subdomain_name
    if self.display_name.blank?
      self.subdomain
    else
      self.display_name
    end
  end

  def domain_name
    self.subdomain + '.' + Myaka::Application.config.aka_domain
  end

  def url
    "https://#{self.domain_name}/"
  end

  def insecure_url
    "http://#{self.domain_name}/"
  end

  def get_or_create_resource path
    self.public_resources.find_by_path(path) || self.public_resources.build(path:path)
  end

  def update_resources
    self.get_or_create_resource("/").save_home_page!
    self.get_or_create_resource("/.well-known/host-meta").save_host_meta!
    self.get_or_create_resource("/.well-known/host-meta.json").save_host_meta_json!
  end

end
