Rails.application.routes.draw do

  class SiteConstraint
    def initialize; end
    def matches?(request)
      ! Site.where(:domain => request.domain).first.nil? && request.subdomain != 'admin'
    end
  end

  constraints(SiteConstraint.new) do
    root :to => "site_logic/pages#show"
    match ':page_slug/', :to => 'site_logic/pages#show'
    match ':page_slug(/:nested_slug)/', :to => 'site_logic/pages#show'
  end
  
  namespace :admin do
    match 'sites/:site_id/nav_items/reorder', :to => 'nav_items#reorder', :as => 'site_reorder_nav_items'
    resources :sites do
      resources :nav_items
      resources :pages
    end
  end
  
end
