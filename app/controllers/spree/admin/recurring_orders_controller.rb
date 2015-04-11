module Spree
  module Admin
    class RecurringOrdersController < ResourceController 

      helper 'application'

      def index
        @recurring_orders = Spree::RecurringOrder.all.select{|order| !order.original_order.nil? }
        @recurring_orders_with_lists = Spree::RecurringOrder.all.select{|order| !order.recurring_lists.empty? }
      end

      def show
        @recurring_order = Spree::RecurringOrder.find_by(number: params[:number])
      end

    end
  end
end
