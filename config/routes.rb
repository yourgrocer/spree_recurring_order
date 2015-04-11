Spree::Core::Engine.routes.draw do

  resources :recurring_orders, only: [:create] 
  resources :recurring_lists, only: [:create, :update]
  resources :recurring_list_items, only: [:destroy]

  namespace :api do
    resources :recurring_lists, only: [:update]
  end


  get "/recurring_orders/:id", controller: 'recurring_orders', action: 'show', as: 'recurring_order'
  get "admin/recurring_orders/", controller: 'admin/recurring_orders', action: 'index', as: 'admin_recurring_orders'
  get "admin/recurring_orders/:number", controller: 'admin/recurring_orders', action: 'show', as: 'admin_recurring_order'
  post "admin/recurring_emails/:number", controller: 'admin/recurring_emails', action: 'create', as: 'admin_recurring_email'

  namespace :admin do
    resources :recurring_lists, only: [:update]
    resources :recurring_orders, only: [:index] do
      resources :recurring_list_orders, only: [:create]
    end
  end
end
