Rails.application.routes.draw do
  class SiteConstraint
    def initialize; end
    def matches?(request)
      !! request.path =~ /admin/ && Site.exists?(:conditions => {:domain => request.host})
    end
  end

  class RedirectConstraint
    def initialize; end
    def matches?(request)
      return false if request.subdomain == 'admin'
      site = Site.where(:domain => request.host).first
      site && site.redirects.where(:source_url => request.path).first
    end
  end

  constraints(RedirectConstraint.new) do
    get ':source_url', :to => 'redirects#show'
  end

  constraints(SiteConstraint.new) do
    root :to => 'pages#show', :via => 'get'
    get '*path' => 'pages#show'
  end

  namespace :admin do
    put 'sites/:site_id/nav_items/reorder', :to => 'nav_items#reorder', :as => 'site_reorder_nav_items'
    resources :sites do
      resources :nav_items
      resources :pages do
        get 'preview', :to => 'pages#preview', :as => 'preview_admin_site_page'
      end
      resources :redirects
    end
  end
end
