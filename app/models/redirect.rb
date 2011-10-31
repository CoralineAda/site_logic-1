class Redirect
  include Mongoid::Document
  include Mongoid::Timestamps

  # Mongoid ========================================================================================
  field :source_url
  field :destination_url
  index :source_url, :unique => true
  embedded_in :site, :inverse_of => :redirects

  # Behavior =======================================================================================
  validates_presence_of :destination_url, :source_url
  validates_uniqueness_of :source_url

  # Instance methods ===============================================================================
  def source_url= url
    self[:source_url] = url.gsub /^http:\/\/.+\.#{self.site.try(:domain)}/, ''
  end
end