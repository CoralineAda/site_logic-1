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
  field :kind
  
  # Indices ========================================================================================

  # Scopes =========================================================================================
  scope :roots,     :where => {:parent_id => nil}
  scope :primary,   :where => {:kind => 'Main'}
  scope :secondary, :where => {:kind => 'Secondary'}
  scope :footer,    :where => {:kind => 'Footer'}
  
  # Relationships ==================================================================================
  embedded_in :site, :inverse_of => :nav_items
  
  # Behavior =======================================================================================
  attr_accessor :status
  
  # Constants ======================================================================================
  
  KINDS = ["Main", "Secondary", "Footer"]

  # Callbacks ======================================================================================

  # Validations ====================================================================================
  validates_presence_of :link_text
  validates_presence_of :link_title
  validates_presence_of :url

  # Class methods ==================================================================================
  
  # Instance methods ===============================================================================

  def children
    self.site.nav_items.where(:parent_id => self.id).sort{|a,b| a.position.to_i <=> b.position.to_i}
  end
  
  def parent
    self.site.nav_items.find(self.parent_id)
  end
  
  def root?
    self.parent_id.nil?
  end
  
  def siblings
    self.parent.children.reject{|c| c == self}
  end
  
  def sub_nav_item?
    self.parent_id
  end

end
