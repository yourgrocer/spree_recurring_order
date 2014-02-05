module Spree
  module Admin
    class RecurringOrdersController < Spree::Admin::BaseController

      def index
        @recurring_orders = Spree::RecurringOrder.all
      end

    end
  end
end
