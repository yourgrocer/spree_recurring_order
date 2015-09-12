module Spree
  module Api
    class RecurringListsController < Spree::Api::BaseController

      before_filter :authorize_user_for_list

      def update
        recurring_list = Spree::RecurringList.find(params[:id])
        if destroy_item?
          success = recurring_list.remove_item(id: item_params[:recurring_list_item][:id])
          if success
            pause_recurring_order!(recurring_list) if recurring_list.items.empty?
            return_success
          else
            return_failure
          end
        else
          item = recurring_list.add_item(item_params[:recurring_list_item])
          item && item.valid? ? return_success(item) : return_failure
        end
      end


      private

      def pause_recurring_order!(recurring_list)
        recurring_list.recurring_order.update_attributes(active: false)
      end

      def destroy_item?
        !params[:recurring_list_item][:destroy].nil?
      end

      def return_success(item=nil)
        result = item.nil? ? 'OK' : item
        render json: result.to_json, status: 200
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
