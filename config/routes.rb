Rails.application.routes.draw do
  devise_for :users, controllers: {
  	           sessions: 'users/sessions',
  	           registrations: 'users/registrations',
  	           passwords: 'users/passwords'
  	    }
	namespace :api do
		namespace :v1 do
  mount_devise_token_auth_for 'User', at: 'auth'
  		end
  	end

  
  root to: 'dashboard#show'

  resources :transfers, except: [:index]
  resources :debits, except: [:index]
  resources :credits, except: [:index] do
    member do
      post 'to_transfer'
    end
  end
  resources :tags
  resources :recurring_credits, only: [:edit, :update, :destroy]
  resources :accounts
  resources :statements, only: [:index]
  resources :billing_accounts do
    resources :bills, shallow: true, except: [:index] do
      post 'pay'
    end
  end

  post 'syncer', to: 'syncer#sync'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
