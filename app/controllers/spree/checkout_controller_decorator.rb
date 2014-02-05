Spree::CheckoutController.class_eval do

  # Provides a route to redirect after order completion
  def completion_route
    spree.order_path(@order, order_completed: true)
  end

end
