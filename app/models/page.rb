class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include SiteLogic::Base
  include Tanker

  # Constants ======================================================================================
  STATES = ['draft', 'published']

  # Scopes =========================================================================================
  scope :drafts,      :where => {:state => 'draft'}
  scope :for_sitemap, :where => {:sitemap => true}
  scope :indexed,     :where => {:noindex => false}
  scope :noindex,     :where => {:noindex => true}
  scope :published,   :where => {:state => 'published'}

  # Mongoid ========================================================================================
  field :slug
  field :sitemap, :type => Boolean
  field :noindex, :type => Boolean
  field :meta_description
  field :meta_keywords
  field :page_title
  field :window_title
  field :content
  field :state
  field :publication_date, :type => DateTime

  index :slug, :unique => false
  index :state, :unique => false

  embedded_in :site, :inverse_of => :pages

  # Behavior =======================================================================================
  attr_accessor :create_navigation_item
  attr_accessor :desired_slug
  has_slug :desired_slug

  # Tanker =========================================================================================
  tankit 'idx' do
    indexes :content
    indexes :meta_description
    indexes :meta_keywords
    indexes :page_title
  end

  after_destroy :delete_tank_indexes
  after_save :update_tank_indexes

  # Validations ====================================================================================
  class DesiredSlugPresenceAndUniquenessValidator < ActiveModel::EachValidator
    def validate_each(object, attribute, value)
      return unless object.desired_slug
      if object.site && object.site.pages.map{|p| p.slug unless p == object}.include?(object.desired_slug)
        object.errors[attribute] << (options[:message] || 'must be unique.')
      end
    end
  end

  validates :desired_slug, :desired_slug_presence_and_uniqueness => true
  validates_presence_of :page_title
  validates_presence_of :content

  # Instance methods ===============================================================================
  def draft?
    self.state == 'draft' || self.state.nil?
  end

  def humanize_path
    self.path
  end

  def path
    self.slug == '' ? '/' : "/#{self.slug}/".gsub(/\/\//,'/').gsub(/\/\//,'/')
  end

  def publish!
    self.update_attributes :state => 'published', :publication_date => Time.zone.now
  end

  def published?
    self.state == 'published'
  end

  def unpublish!
    self.update_attributes :state => 'draft', :publication_date => nil
  end

  def search_description
    self.meta_description.blank? ? self.content.gsub(/<\/?[^>]*>/, '')[0..199].html_safe : self.meta_description
  end

  def search_title
    self.window_title
  end

  def sitemap
    self[:sitemap] || true
  end

  def status
    self.state ? self.state.capitalize : 'Draft'
  end

  def window_title
    self[:window_title] || self.page_title
  end
end