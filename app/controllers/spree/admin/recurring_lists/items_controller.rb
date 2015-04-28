module Spree
  module Admin::RecurringLists
    class ItemsController < Spree::Admin::BaseController

      def create
        load_list
        @variant = Spree::Variant.find(params[:variant_id])
        if @variant && @recurring_list.add_item({variant_id: @variant.id, quantity: params[:quantity]})
          flash[:success] = "Item with #{@variant.sku} added to regular order"
        else
          flash[:error] = "Failed adding #{params[:sku]}"
        end

        redirect_to(admin_recurring_order_url(@recurring_list.recurring_order.number))
      end

      def destroy
        load_list
        @recurring_list_item = @recurring_list.items.where(id: params[:id]).first
        
        if @recurring_list_item
          @recurring_list_item.destroy
          render nothing: true, status: 200
        else
          render text: 'item not found', status: 404
        end
      end

      private

      def load_list
        @recurring_list = Spree::RecurringList.find(params[:recurring_list_id])
      end
    end
  end
end
