class Site

  include Mongoid::Document
  include Mongoid::Timestamps
  include SiteLogic::Base

  # Attributes =====================================================================================

  field :domain  
  field :name  
  field :layout
  field :state  
  field :redirect_to  
  field :google_profile_id  
  field :google_webmaster_code  
  field :yahoo_webmaster_code  
  field :bing_webmaster_code  
  field :netinsert_code  
  field :activation_date, :type => DateTime
  
  # Indices ========================================================================================
  index :domain, :unique => true
  index :name, :unique => true
  
  # Constants ======================================================================================
  STATES = ['inactive', 'active']
  
  # Scopes ===================================================================================
  scope :active,   :where => {:state => 'active'}
  scope :inactive, :where => {:state => 'inactive'}

  # Relationships ==================================================================================
  embeds_many :pages
  embeds_many :nav_items
  embeds_many :redirects
  
  # Behavior =======================================================================================
  attr_accessor :status
  
  # Callbacks ======================================================================================

  # Validations ====================================================================================
  validates_presence_of :domain
  validates_uniqueness_of :domain
  validates_presence_of :name
  validates_uniqueness_of :name

  # Class methods ==================================================================================

  def self.layouts
    basedir = "#{Rails.root.to_s}/app/views/layouts/"
    files = Dir.glob("#{Rails.root.to_s}/app/views/layouts/*.html.erb")
    files.map{|f| f.gsub(/.+layouts\/(.+)\.html.erb/, '\1')}
  end
  
  # Instance methods ===============================================================================

  def active?
    self.state == "active"
  end
  
  def activate!
    self.update_attributes(:state => 'active', :activation_date => Time.zone.now)
  end
  
  def deactivate!
    self.update_attributes(:state => 'inactive', :activation_date => nil)
  end

  def footer_navigation
    self.nav_items.footer(:order => :position)
  end
  
  def home_page
    self.pages.where(:slug => '/').first
  end
  
  def inactive?
    self.state != "active"
  end

  def primary_navigation
    self.nav_items.primary(:order => :position)
  end
  
  def secondary_navigation
    self.nav_items.secondary(:order => :position)
  end
  
  def state
    self[:state] || 'inactive'
  end
  
  def status
    self.state.capitalize
  end
  
end
