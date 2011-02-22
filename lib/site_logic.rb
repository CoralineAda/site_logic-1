module SiteLogic

  require 'mongoid'
  require 'site_logic/engine' if defined?(Rails)
  require 'site_logic/railtie' if defined?(Rails)
  require 'site_logic/base'
  require 'site_logic/navigation'
  
  mattr_accessor :navigation_options
  mattr_accessor :primary_nav
  mattr_accessor :secondary_nav
  mattr_accessor :footer_nav
  
  def self.setup
    yield self
  end

  def self.navigation_options
    navigation_options ||= {
      :primary => {
        :label => "Primary Navigation",
        :description => "Primary navigation items appear in the main navigation bar on each page."
      },
      :secondary => {
        :label => "Secondary Navigation",
        :description => "Secondary navigation items appear at the top of each page, above the main navigation bar."
      },
      :footer => {
        :label => "Footer Navigation",
        :description => "Footer navigation items appear at the bottom of each page."
      }
    }
  end
  
  def self.primary_nav
    primary_nav ||= Navigation.new(
      :kind => :primary,
      :label => self.navigation_options[:primary][:label],
      :description => self.navigation_options[:primary][:description]
    )
  end

  def self.secondary_nav
    secondary_nav ||= Navigation.new(
      :kind => :primary,
      :label => self.navigation_options[:secondary][:label],
      :description => self.navigation_options[:secondary][:description]
    )
  end

  def self.footer_nav
    footer_nav ||= Navigation.new(
      :kind => :primary,
      :label => self.navigation_options[:footer][:label],
      :description => self.navigation_options[:footer][:description]
    )
  end
  
end
