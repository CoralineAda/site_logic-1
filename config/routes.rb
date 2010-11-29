Rails.application.routes.draw do

  class SiteConstraint
    def initialize; end
    def matches?(request)
      Site.where(:domain => request.domain)
    end
  end

  constraints(SiteConstraint.new) do
    root :to => "pages#show"
    match ':page_slug/', :to => 'pages#show'
    match ':page_slug(/:nested_slug)/', :to => 'pages#show'
  end
  
  namespace :admin do
    root :to => "admin/sites#index"
    resources :sites do
      resources :pages
    end
  end

  
end
