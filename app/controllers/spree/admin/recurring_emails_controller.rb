module Spree
  module Admin
    class RecurringEmailsController < Spree::Admin::BaseController

      def create
        order = Spree::Order.find_by(number: params[:number])
        order.deliver_recurring_order_email
        redirect_to(edit_admin_order_path(order))
      end

    end
  end
end
