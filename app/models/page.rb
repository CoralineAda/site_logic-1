class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tanker if defined? Tanker

  # Constants ======================================================================================
  STATES = ['draft', 'published']

  # Scopes =========================================================================================
  scope :by_slug, lambda{ |slug| {:where => {:slug => slug}} }
  scope :drafts,      :where => {:state => /draft/i}
  scope :for_sitemap, :where => {:sitemap => true}
  scope :indexed,     :where => {:noindex => false}
  scope :leading_slash, :where => {:slug => %r{^\/}}
  scope :noindex,     :where => {:noindex => true}
  scope :published,   :where => {:state => /published/i}
  scope :trailing_slash, :where => {:slug => %r{\/$}}

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
  before_save :set_slug
  validates_presence_of :content, :page_title
  validates_uniqueness_of :slug

  # Tanker =========================================================================================
  tankit 'idx' do
    indexes :content
    indexes :meta_description
    indexes :meta_keywords
    indexes :page_title
  end if defined? Tanker

  after_destroy :delete_tank_indexes unless Rails.application.config.tanker_disabled
  after_save :update_tank_indexes unless Rails.application.config.tanker_disabled

  # Instance methods ===============================================================================
  def draft?
    self.state == 'draft' || self.state.nil?
  end

  # @deprecated Please use {#path} instead
  def humanize_path
    warn "[DEPRECATION] `humanize_path` is deprecated.  Please use `path` instead."
    self.path
  end

  # Returns this page's path.
  #
  # @return [String] the path for this page
  def path
    self.slug == '' ? '/' : "/#{self.slug}".gsub('//', '/')
  end

  def publish!
    self.update_attributes :state => 'published', :publication_date => Time.zone.now
  end

  def published?
    self.state == 'published'
  end

  def root?
    self.slug == '/'
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

  def strip_leading_slash
    self.slug = self.slug[1..-1] if leading_slash?
  end

  def strip_trailing_slash
    self.slug = self.slug[0..-2] if trailing_slash?
  end

  def window_title
    self[:window_title] || self.page_title
  end

  private

  def leading_slash?
    self.slug.try(:first) == '/' && ! root?
  end

  def set_slug
    self.slug = self.window_title.to_s.to_url if self.slug.blank?
    self.strip_leading_slash
    self.strip_trailing_slash
  end

  def trailing_slash?
    self.slug.try(:last) == '/' && ! root?
  end
end