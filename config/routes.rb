Rails.application.routes.draw do
  resources :billing_accounts
  devise_for :users, controllers: {
  	  sessions: 'users/sessions',
  	  registrations: 'users/registrations',
  	  passwords: 'users/passwords'
  }
  root to: 'statements#graph'

  resources :transfers
  resources :debits
  resources :credits do
    member do
      post 'to_transfer'
    end
  end
  resources :tags
  resources :recurring_credits
  resources :accounts
  resources :statements, only: [:index] do
    collection do
      get 'graph'
    end
  end

  post 'syncer', to: 'syncer#sync'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
