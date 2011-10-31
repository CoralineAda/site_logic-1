class NavItem
  include Mongoid::Document
  include Mongoid::Timestamps

  # Constants ======================================================================================
  KINDS = ['Main', 'Secondary', 'Footer']

  # Mongoid ========================================================================================
  field :link_title
  field :link_text
  field :url
  field :parent_id
  field :position, :type => Integer
  field :obfuscate, :type => Boolean
  field :kind
  embedded_in :site, :inverse_of => :nav_items
  scope :roots,     :where => {:parent_id => nil}
  scope :primary,   :where => {:kind => 'Main'}
  scope :secondary, :where => {:kind => 'Secondary'}
  scope :footer,    :where => {:kind => 'Footer'}

  # Behavior =======================================================================================
  attr_accessor :status
  attr_accessor :creating_page

  # Validations ====================================================================================
  validates_presence_of :link_text
  validates_presence_of :link_title
  validates_presence_of :url

  # Instance methods ===============================================================================
  def children
    self.site.nav_items.select{|ni| ni.parent_id == self.id.to_s}.sort_by{|ni| ni.position.to_i}
  end

  def decoded_url
    self[:url]
  end

  def encoded_url
    self[:url].gsub('/', '#').tr('A-Ma-mN-Zn-z', 'N-Zn-zA-Ma-m')
  end

  def omit_from_sitemap?
    self.decoded_url == '/' || self.decoded_url.include?('site-map')
  end

  def parent
    self.site.nav_items.find self.parent_id
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

  def url
    @url = self.obfuscate? ? encoded_url : self[:url]
  end
end