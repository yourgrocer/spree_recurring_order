module Spree
  module Admin
    module RecurringOrders
      class RecurringListOrdersController < Spree::Admin::BaseController

        def create
          @recurring_order = Spree::RecurringOrder.find(params[:recurring_order_id])

          @order = Order.create
          @order.email = @recurring_order.base_list.user.email
          @order.created_by = @recurring_order.base_list.user
          @order.save

          render json: {}
        end

      end
    end
  end
end
