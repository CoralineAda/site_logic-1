module SiteLogic
  require 'site_logic/navigation'
  require 'site_logic/railtie' if defined?(Rails)

  mattr_accessor :navigation_options
  mattr_accessor :primary_nav
  mattr_accessor :secondary_nav
  mattr_accessor :footer_nav

  module SiteLogic
    class Engine < Rails::Engine
    end
  end

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
    primary_nav ||= new_navigation_with_kind(:primary)
  end

  def self.secondary_nav
    secondary_nav ||= new_navigation_with_kind(:secondary)
  end

  def self.footer_nav
    footer_nav ||= new_navigation_with_kind(:footer)
  end

  private

  def self.new_navigation_with_kind kind
    Navigation.new(
      :kind => kind,
      :label => self.navigation_options[kind][:label],
      :description => self.navigation_options[kind][:description]
    )
  end
end