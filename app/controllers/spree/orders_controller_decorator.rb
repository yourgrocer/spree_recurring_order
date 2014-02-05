Spree::OrdersController.class_eval do

  def show
    @order = Spree::Order.find_by_number!(params[:id])
    @recurring_order = Spree::RecurringOrder.new
  end

end
