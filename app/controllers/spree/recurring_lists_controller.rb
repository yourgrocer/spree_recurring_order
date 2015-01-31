module Spree
  class RecurringListsController < Spree::StoreController

    def create
      @recurring_list = Spree::RecurringList.new(list_params)
      recurring_order = Spree::RecurringOrder.new
      recurring_order.recurring_lists << @recurring_list

      if @recurring_list.save && recurring_order.save
        redirect_to account_url
      else
        render :new, status: 400
      end
    end

    private

    def list_params
      recurring_list_params = params["recurring_list"]
      if recurring_list_params["items_attributes"]
        old_params = recurring_list_params.delete("items_attributes")
        recurring_list_params["items_attributes"] = []
        old_params.each_value {|value| recurring_list_params["items_attributes"] << value if value["selected"] == '1' }
      end

      recurring_list_params.permit(:user_id, :next_delivery_date, :timeslot, items_attributes: [:variant_id, :quantity])
    end

  end
end
