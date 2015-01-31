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

    def update
      @recurring_list = Spree::RecurringList.find(params[:id])
      @recurring_list.update_attributes({id: params[:id]}.merge(list_params))
      redirect_to account_url
    end

    private

    def list_params
      recurring_list_params = params["recurring_list"].clone
      if recurring_list_params["items_attributes"]
        old_params = recurring_list_params.delete("items_attributes")
        recurring_list_params["items_attributes"] = []
        old_params.each_value {|value| recurring_list_params["items_attributes"] << value if value["selected"] == '1' }
      end

      recurring_list_params.permit(:id, :user_id, :next_delivery_date, :timeslot, items_attributes: [:id, :variant_id, :quantity])
    end

  end
end
