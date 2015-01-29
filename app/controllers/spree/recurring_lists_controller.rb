module Spree
  class RecurringListsController < Spree::StoreController

    def create
      debugger
      @recurring_list = Spree::RecurringList.new(list_params)

      if @recurring_list.save
        redirect_to account_url
      else
        render :new, status: 400
      end
    end

    private
    
    def list_params
      formatted_params = params[:recurring_list].permit(:user_id, items_attributes: [:variant_id, :quantity])
      if formatted_params["items_attributes"]
        old_params = formatted_params.delete("items_attributes")
        formatted_params["items_attributes"] = []
        old_params.each_value {|value| formatted_params["items_attributes"] << value}
      end
      formatted_params
    end

  end
end
