module Spree
  module Admin
    class RecurringListOrdersController < Spree::Admin::BaseController

      def create
        @recurring_order = Spree::RecurringOrder.find(params[:recurring_order_id])

        if base_list.nil?
          fail_with_message('Recurring order does not have a base list')
        elsif order_to_merge && order_to_merge.delivery_date
          fail_with_message('User has already an existing incomplete order with delivery date set')
        else
          @order = Spree::Order.create
          @order.recurring_order = @recurring_order
          @order.email = base_list.user.email
          @order.created_by = base_list.user
          @order.user = base_list.user

          @order.ship_address = ship_address(base_list) 
          @order.bill_address = bill_address(base_list) 

          set_extended_values

          @order.save!

          @order.merge!(order_to_merge) if (order_to_merge && order_to_merge != @order)
          order_contents = Spree::OrderContents.new(@order)
          base_list.items.each do |item|
            order_contents.add(item.variant, item.quantity)
          end

          redirect_to(edit_admin_order_url(@order.number))
        end
      end

      private

      def fail_with_message(message)
        flash[:error] = "Order creation failed - #{message}" 
        redirect_to(admin_recurring_order_url(@recurring_order.number))
      end

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

      def order_to_merge
        @order_to_merge ||= base_list.nil? ? nil : base_list.user.last_incomplete_spree_order
        @order_to_merge
      end

    end
  end
end
