Rails.application.routes.draw do
  resources :plants, only: [:index, :show]
  devise_for :users
  root 'home#index'
  authenticate :user do
    get 'my_account', to: 'account#index'
  end
end
