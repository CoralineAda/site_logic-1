class Redirect

  include Mongoid::Document
  include Mongoid::Timestamps
  include SiteLogic::Base

  # Attributes =====================================================================================

  field :source_url
  field :destination_url

  # Indices ========================================================================================
  index :source_url, :unique => true

  # Constants ======================================================================================

  # Scopes ===================================================================================

  # Relationships ==================================================================================
  embedded_in :site, :inverse_of => :redirects

  # Behavior =======================================================================================

  # Callbacks ======================================================================================

  # Validations ====================================================================================
  validates_presence_of   :source_url
  validates_presence_of   :destination_url
  validates_uniqueness_of :source_url

  # Class methods ==================================================================================

  # Instance methods ===============================================================================

  def source_url=(url)
    self[:source_url] = url.gsub(/^http:\/\/.+\.#{self.site.domain}/,'')
  end

end
