module Spree
  module Api
    class RecurringListsController < Spree::Api::BaseController

      def update
        recurring_list = Spree::RecurringList.find(params[:id])
        recurring_list.add_item(item_params[:recurring_list_item])

        render json: 'OK', status: 201
      end

      private

      def item_params
        params.permit(recurring_list_item: [:variant_id, :quantity])
      end

    end

  end
end
