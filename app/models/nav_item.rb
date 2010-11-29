class NavItem

  include Mongoid::Document
  include Mongoid::Timestamps
  include SiteLogic::Base

  # Attributes =====================================================================================

  field :link_title  
  field :link_text 
  field :url
  field :parent_id  
  field :position, :type => Integer
  
  # Indices ========================================================================================

  # Scopes =========================================================================================

  scope :roots, :where => {:parent_id => nil}

  # Relationships ==================================================================================
  embedded_in :site, :inverse_of => :nav_items
  
  # Behavior =======================================================================================
  attr_accessor :status
  
  # Callbacks ======================================================================================

  # Validations ====================================================================================
  validates_presence_of :link_text
  validates_presence_of :link_title
  validates_presence_of :url
  validates_uniqueness_of :url

  # Class methods ==================================================================================
  
  # Instance methods ===============================================================================

end
