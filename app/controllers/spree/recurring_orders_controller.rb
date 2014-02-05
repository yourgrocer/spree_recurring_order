module Spree
  class RecurringOrdersController < Spree::StoreController

    def create
      original_order = Spree::Order.find(recurring_order_params[:original_order_id])
      @recurring_order = Spree::RecurringOrder.new
      @recurring_order.original_order = original_order

      if @recurring_order.save
        redirect_to(spree.recurring_order_url(@recurring_order.id))
      else
        render :new
      end
    end

    def show
      @recurring_order = Spree::RecurringOrder.find(params[:id])
    end

    private

    def recurring_order_params
      params[:recurring_order].permit(:original_order_id)
    end

  end
end
