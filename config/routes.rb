Spree::Core::Engine.routes.draw do
  resource :recurring_orders, only: [:create]
  get "/recurring_orders/:id", controller: 'recurring_orders', action: 'show', as: 'recurring_order'
end
