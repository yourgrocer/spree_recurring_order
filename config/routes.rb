Spree::Core::Engine.routes.draw do

  resource :recurring_orders, only: [:create]
  resource :recurring_lists, only: [:create]

  get "/recurring_orders/:id", controller: 'recurring_orders', action: 'show', as: 'recurring_order'
  get "admin/recurring_orders/", controller: 'admin/recurring_orders', action: 'index', as: 'admin_recurring_orders'
  get "admin/recurring_orders/:number", controller: 'admin/recurring_orders', action: 'show', as: 'admin_recurring_order'
  post "admin/recurring_emails/:number", controller: 'admin/recurring_emails', action: 'create', as: 'admin_recurring_email'
end
