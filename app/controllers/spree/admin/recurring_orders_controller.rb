module Spree
  module Admin
    class RecurringOrdersController < Spree::Admin::BaseController

      def index
        @recurring_orders = Spree::RecurringOrder.all
      end

      def show
        @recurring_order = Spree::RecurringOrder.find_by(number: params[:number])
      end

    end
  end
end
