Rails.application.routes.draw do

  class SiteConstraint
    def initialize; end
    def matches?(request)
      ! Site.where(:domain => request.host).first.nil? && request.subdomain != 'admin'
    end
  end

  class RedirectConstraint
    def initialize; end
    def matches?(request)
      return false if request.subdomain == 'admin'
      site = Site.where(:domain => request.domain).first
      site && site.redirects.where(:source_url => "#{request.path}").first
    end
  end

  constraints(RedirectConstraint.new) do
    match ':source_url', :to => 'redirects#show'
  end
  
  constraints(SiteConstraint.new) do
    root :to => "pages#show"
    match ':page_slug/', :to => 'pages#show'
    match ':page_slug(/:nested_slug)/', :to => 'pages#show'
  end
  
  namespace :admin do
    match 'sites/:site_id/nav_items/reorder', :to => 'nav_items#reorder', :as => 'site_reorder_nav_items'
    resources :sites do
      resources :nav_items
      resources :pages do
        match 'preview', :to => 'pages#preview', :as => 'preview_admin_site_page'
      end
      resources :redirects
    end
  end
  
end
