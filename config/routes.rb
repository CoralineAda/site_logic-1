SiteLogic::Application.routes.draw do

  class SiteConstraint
    def initialize; end
    def matches?(request)
      Site.where(:domain => request.domain)
    end
  end

  constraints(SiteConstraint.new) do
    match ':page_slug/', :to => 'pages#show'
  end
  
  namespace :admin do
    resources :sites do
      resources :pages
    end
  end

  resources :sites, :only => :show do
    resources :pages, :only => :show
  end
  
  root :to => "admin/sites#index"

end
