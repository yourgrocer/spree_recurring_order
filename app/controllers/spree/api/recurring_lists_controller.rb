module Spree
  module Api
    class RecurringListsController < Spree::Api::BaseController

      before_filter :authorize_user_for_list

      def update
        recurring_list = Spree::RecurringList.find(params[:id])
        recurring_list.add_item(item_params[:recurring_list_item])

        render json: 'OK'.to_json, status: 200
      end

      private

      def authorize_user_for_list
        recurring_list = Spree::RecurringList.find(params[:id])
        if recurring_list.user_id != current_api_user.id
          render "spree/api/errors/unauthorized", :status => 401 and return
        end
      end

      def item_params
        params.permit(recurring_list_item: [:variant_id, :quantity])
      end

    end

  end
end
