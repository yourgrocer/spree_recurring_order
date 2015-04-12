module Spree
  module Admin
    class RecurringOrdersController < ResourceController 

      helper 'application'

      skip_before_action :load_resource, only: [:update]

      def index
        @recurring_orders = Spree::RecurringOrder.all.select{|order| !order.original_order.nil? }
        @recurring_orders_with_lists = Spree::RecurringOrder.all.select{|order| !order.recurring_lists.empty? }
      end

      def show
        @recurring_order = Spree::RecurringOrder.find_by(number: params[:number])
      end

      def update
        @recurring_order = Spree::RecurringOrder.find_by(number: params[:id])
        @recurring_order.update_attributes(update_params)
        render :show
      end

      private

      def update_params
        params.permit(:active)
      end

    end
  end
end
