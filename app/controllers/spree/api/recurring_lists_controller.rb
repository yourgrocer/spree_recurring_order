module Spree
  module Api
    class RecurringListsController < Spree::Api::BaseController

      before_filter :authorize_user_for_list

      def update
        recurring_list = Spree::RecurringList.find(params[:id])
        if destroy_item?
          recurring_list.remove_item(id: item_params[:recurring_list_item][:id]) ? return_success : return_failure
        else
          recurring_list.add_item(item_params[:recurring_list_item]) ? return_success : return_failure
        end
      end


      private

      def destroy_item?
        !params[:recurring_list_item][:destroy].nil?
      end

      def return_success
        render json: 'OK'.to_json, status: 200
      end

      def return_failure
        render json: 'Update failed'.to_json, status: 400
      end

      def authorize_user_for_list
        recurring_list = Spree::RecurringList.find(params[:id])
        if recurring_list.user_id != current_api_user.id
          render "spree/api/errors/unauthorized", :status => 401 and return
        end
      end

      def item_params
        params.permit(recurring_list_item: [:id, :variant_id, :quantity])
      end

    end

  end
end
