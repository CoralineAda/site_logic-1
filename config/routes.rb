Rails.application.routes.draw do

  class SiteConstraint
    def initialize; end
    def matches?(request)
      ! Site.where(:domain => request.domain).first.nil?
    end
  end

  constraints(SiteConstraint.new) do
    root :to => "site_logic/pages#show"
    match ':page_slug/', :to => 'site_logic/pages#show'
    match ':page_slug(/:nested_slug)/', :to => 'site_logic/pages#show'
  end
  
  namespace :admin do
    root :to => "site_logic/admin/sites#index"
    resources :sites do
      resources :pages
    end
  end
  
end
