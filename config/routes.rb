Rails.application.routes.draw do
  resources :transfers
  resources :debits
  resources :recurring_debits
  resources :credits
  resources :tags
  resources :recurring_credits
  resources :accounts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
