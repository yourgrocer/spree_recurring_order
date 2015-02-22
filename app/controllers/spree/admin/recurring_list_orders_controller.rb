module Spree
  module Admin
    class RecurringListOrdersController < Spree::Admin::BaseController

      def create
        @recurring_order = Spree::RecurringOrder.find(params[:recurring_order_id])

        @order = Order.create
        @order.recurring_order = @recurring_order
        @order.email = base_list.user.email
        @order.created_by = base_list.user
        @order.user = base_list.user

        @order.ship_address = ship_address(base_list) 
        @order.bill_address = bill_address(base_list) 

        set_extended_values

        @order.save!

        order_contents = Spree::OrderContents.new(@order)
        base_list.items.each do |item|
          order_contents.add(item.variant, item.quantity)
        end

        redirect_to(edit_admin_order_url(@order.number))
      end

      private

      def set_extended_values
        #To be overriden
      end

      def ship_address(base_list) 
        base_list.user.orders.complete.last.ship_address.dup
      end

      def bill_address(base_list) 
        base_list.user.orders.complete.last.bill_address.dup
      end

      def base_list
        @recurring_order.base_list
      end

    end
  end
end
