class Page

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
  
  # Indices ========================================================================================
  index :slug, :unique => true
  index :state, :unique => false

  # Constants ======================================================================================
  STATES = ['draft', 'published']

  # Scopes ===================================================================================
  scope :drafts,    :where => {:state => 'draft'}
  scope :published, :where => {:state => 'published'}

  # Relationships ==================================================================================
  embedded_in :site, :inverse_of => :pages
  
  # Behavior =======================================================================================
  attr_accessor :desired_slug
  has_slug :desired_slug
  
  # Callbacks ======================================================================================

  # Validations ====================================================================================

  class DesiredSlugPresenceValidator < ActiveModel::EachValidator
    def validate_each(object, attribute, value)
      unless object.desired_slug || object.slug
        object.errors[attribute] << (options[:message] || "cannot be blank.")
      end
    end
  end
  
  validates :desired_slug, :desired_slug_presence => true
  validates_presence_of :page_title
  validates_uniqueness_of :page_title
  validates_presence_of :content
  
  # Class methods ==================================================================================

  # Instance methods ===============================================================================

  def publish!
    self.update_attributes(:state => 'published', :publication_date => Time.zone.now)
  end
  
end
