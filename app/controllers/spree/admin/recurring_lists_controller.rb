module Spree
  module Admin
    class RecurringListsController < Spree::Admin::BaseController

      def update
        recurring_list = Spree::RecurringList.find(params[:id])

        if recurring_list.update_attributes(list_params) 
          flash[:success] = "Regular order updated successfully"
        else
          flash[:error] = "There was a problem updating the regular order"
        end

        redirect_to admin_recurring_order_url(recurring_list.recurring_order.number)
      end

      private

      def list_params
        params.require(:recurring_list).permit(:next_delivery_date, :timeslot)
      end

    end
  end
end
