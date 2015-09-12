module Spree
  module Admin
    class RecurringListOrdersController < Spree::Admin::BaseController

      def create
        @recurring_order = Spree::RecurringOrder.find(params[:recurring_order_id])
        if base_list.nil?
          fail_with_message('Recurring order does not have a base list')
        else
          @recurring_order.save
          new_order = @recurring_order.create_order_from_base_list
          if new_order.valid?
            redirect_to(edit_admin_order_url(new_order.number))
          else
            fail_with_message("#{new_order.errors.full_messages.first}")
          end
        end
      end

      private

      def fail_with_message(message)
        flash[:error] = "Order creation failed - #{message}"
        redirect_to(admin_recurring_order_url(@recurring_order.number))
      end

      def base_list
        @recurring_order.base_list
      end

    end
  end
end
