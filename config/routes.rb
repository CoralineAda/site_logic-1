Rails.application.routes.draw do
  constraints(SiteLogic::RedirectConstraint.new) do
    match ':source_url', :to => 'site_logic/redirects#show'
  end
  
  constraints(SiteLogic::SiteConstraint.new) do
    root :to => "site_logic/pages#show"
    match ':page_slug/', :to => 'site_logic/pages#show'
    match ':page_slug(/:nested_slug)/', :to => 'site_logic/pages#show'
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
