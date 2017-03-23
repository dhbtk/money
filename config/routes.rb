Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]

  root to: 'home#show'

  scope '/api' do
    resources :transfers, except: [:index]
    resources :debits, except: [:index]
    resources :credits, except: [:index] do
      member do
        post 'to_transfer'
      end
    end
    resources :categories
    resources :recurring_credits, only: [:edit, :update, :destroy]
    resources :accounts
    resources :statements, only: [:index] do
      collection do
        get 'report'
      end
    end
    resources :billing_accounts do
      resources :bills, shallow: true, except: [:index] do
        post 'pay'
        get 'pay_form'
        member do
          get 'attachment'
        end
      end
    end

    post 'sync', to: 'syncer#sync'
  end

  %w(/transfers /debits /credits /categories /recurring_credits /accounts /statements /billing_accounts /bills).each do |segment|
    get segment, to: 'home#show'
    get segment + '/:a', to: 'home#show'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
