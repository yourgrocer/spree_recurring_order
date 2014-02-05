Spree::Core::Engine.routes.draw do

  resource :recurring_orders, only: [:create]
  get "/recurring_orders/:id", controller: 'recurring_orders', action: 'show', as: 'recurring_order'

  get "admin/recurring_orders/", controller: 'admin/recurring_orders', action: 'index', as: 'admin_recurring_orders'
end
