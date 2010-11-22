class Site

  include Mongoid::Document
  include Mongoid::Timestamps
  include SiteLogic::Base

  # Attributes =====================================================================================

  field :domain  
  field :name  
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
  
  # Behavior =======================================================================================
  attr_accessor :status
  
  # Callbacks ======================================================================================

  # Validations ====================================================================================
  validates_presence_of :domain
  validates_uniqueness_of :domain
  validates_presence_of :name
  validates_uniqueness_of :name

  # Class methods ==================================================================================

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

  def inactive?
    self.state != "active"
  end

  def state
    self[:state] || 'inactive'
  end
  
  def status
    self.state.capitalize
  end
  
end
