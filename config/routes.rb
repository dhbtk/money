Rails.application.routes.draw do

  resources :billing_accounts do
    resources :bills, shallow: true, except: [:index] do
      post 'pay'
    end
  end
  devise_for :users, controllers: {
  	  sessions: 'users/sessions',
  	  registrations: 'users/registrations',
  	  passwords: 'users/passwords'
  }
  root to: 'dashboard#show'

  resources :transfers, except: [:index, :show]
  resources :debits, except: [:index, :show]
  resources :credits, except: [:index, :show] do
    member do
      post 'to_transfer'
    end
  end
  resources :tags, except: [:show]
  resources :recurring_credits, only: [:edit, :update, :destroy]
  resources :accounts
  resources :statements, only: [:index]

  post 'syncer', to: 'syncer#sync'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
