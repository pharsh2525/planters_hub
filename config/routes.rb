Rails.application.routes.draw do
  ActiveAdmin.routes(self)
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
    post 'update_address', to: 'carts#update_address', as: 'update_address'
    post 'place_order', to: 'carts#place_order', as: 'place_order'
    # config/routes.rb
    get 'order_success/:id', to: 'carts#order_success', as: 'order_success'

  end

  # Add a route for the success page after placing an order
  get 'order_success/:id', to: 'orders#success', as: 'order_success'

  resources :orders, only: [:index, :show]
  resources :addresses
  resources :payment_methods

  patch 'cart/update_quantity/:plant_id', to: 'carts#update_quantity', as: 'update_quantity_cart'

  delete '/admin/plants/:plant_id/delete_image/:image_id', to: 'admin/plants#delete_image', as: :admin_plant_delete_image
end
