Rails.application.routes.draw do
  devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords'
  }

  root to: 'dashboard#show'

  get 'dashboard/calendar/:year/:month', to: 'dashboard#calendar'

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
      get 'pay_form'
      member do
        get 'attachment'
      end
    end
  end

  post 'syncer', to: 'syncer#sync'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
