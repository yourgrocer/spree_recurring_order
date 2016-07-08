module Spree
  module Api
    class RecurringListsController < Spree::Api::BaseController

      before_filter :verify_logged_in_user

      def update
        recurring_list = Spree::RecurringList.find(params[:id])
        authorize! :update, recurring_list

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

      def item_params
        params.permit(recurring_list_item: [:id, :variant_id, :quantity])
      end

    end

  end
end
