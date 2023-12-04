Rails.application.routes.draw do
  resources :plants, only: [:index, :show]
  devise_for :users
  root 'home#index'

  authenticate :user do
    get 'my_account', to: 'account#index'
  end

  resource :cart, only: [:show] do
    post 'add/:plant_id', to: 'carts#add', as: 'add_to'
    delete 'remove/:plant_id', to: 'carts#remove', as: 'remove_from'
    delete 'clear', to: 'carts#clear', as: 'clear'
    get 'checkout', to: 'carts#checkout', as: 'checkout'
  end

  patch 'cart/update_quantity/:plant_id', to: 'carts#update_quantity', as: 'update_quantity_cart'
end
