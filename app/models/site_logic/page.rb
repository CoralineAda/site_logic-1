class SiteLogic::Page

  include Mongoid::Document
  include Mongoid::Timestamps
  include SiteLogic::Base

  # Attributes =====================================================================================

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
  
  # Indices ========================================================================================
  index :slug, :unique => false
  index :state, :unique => false

  # Constants ======================================================================================
  STATES = ['draft', 'published']

  # Scopes ===================================================================================
  scope :drafts,      :where => {:state => 'draft'}
  scope :published,   :where => {:state => 'published'}
  scope :noindex,     :where => {:noindex => true}
  scope :indexed,     :where => {:noindex => false}
  scope :for_sitemap, :where => {:sitemap => true}
  
  # Relationships ==================================================================================
  embedded_in :site, :inverse_of => :pages
  
  # Behavior =======================================================================================
  attr_accessor :desired_slug
  has_slug :desired_slug
  
  # Callbacks ======================================================================================

  # Validations ====================================================================================

  class DesiredSlugPresenceAndUniquenessValidator < ActiveModel::EachValidator
    def validate_each(object, attribute, value)
      return unless object.desired_slug
      if object.site && object.site.pages.map{|p| p.slug unless p == object}.include?(object.desired_slug)
        object.errors[attribute] << (options[:message] || "must be unique.")
      end

#       if object.desired_slug.nil? && object.slug.nil?
#         object.errors[attribute] << (options[:message] || "cannot be blank.")
#       elsif object.site && object.site.pages.map{|p| p.slug unless p == object}.include?(object.desired_slug)
#         object.errors[attribute] << (options[:message] || "must be unique.")
#       end
    end
  end
  
  validates :desired_slug, :desired_slug_presence_and_uniqueness => true
  validates_presence_of :page_title
  validates_presence_of :content
  
  # Class methods ==================================================================================

  # Instance methods ===============================================================================

  def draft?
    self.state == 'draft' || self.state.nil?
  end

  def humanize_path
    if self.slug == ''
      "/"
    else
      "/#{self.slug}/".gsub(/\/\//,'/').gsub(/\/\//,'/')
    end
  end
    
  def publish!
    self.update_attributes(:state => 'published', :publication_date => Time.zone.now)
  end
  
  def published?
    self.state == 'published'
  end
  
  def unpublish!
    self.update_attributes(:state => 'draft', :publication_date => nil)
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
