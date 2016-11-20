Rails.application.routes.draw do
  devise_for :users, controllers: {
  	  sessions: 'users/sessions',
  	  registrations: 'users/registrations',
  	  passwords: 'users/passwords'
  }
  root to: 'statements#index'

  resources :transfers
  resources :debits
  resources :recurring_debits
  resources :credits do
    member do
      post 'to_transfer'
    end
  end
  resources :tags
  resources :recurring_credits
  resources :accounts
  resources :statements
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
