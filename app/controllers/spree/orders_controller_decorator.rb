Spree::OrdersController.class_eval do

  def show
    @present_recurring = params["order_completed"] ? true : false

    @order = Spree::Order.find_by_number!(params[:id])
    @recurring_order = Spree::RecurringOrder.new
  end

end
