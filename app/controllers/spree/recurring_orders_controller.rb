module Spree
  class RecurringOrdersController < Spree::StoreController

    before_filter :check_authorization
 
    def create
      original_order = Spree::Order.find(params[:original_order_id])
      @recurring_order = Spree::RecurringOrder.new
      @recurring_order.original_order = original_order

      if @recurring_order.save
        redirect_to("/recurring_orders/#{@recurring_order.id}")
      else
        render :new
      end
    end

    def show
      @recurring_order = Spree::RecurringOrder.find(params[:id])
    end

  end
end
