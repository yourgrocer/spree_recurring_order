module Spree
  class RecurringListsController < Spree::StoreController

    def create
      @recurring_list = Spree::RecurringList.new(user_id: list_params[:user_id])
      list_params[:recurring_list_items].each do |item|
        @recurring_list.items << Spree::RecurringListItem.new(variant_id: item[:variant_id], quantity: item[:quantity])
      end
      @recurring_list.save
      render :show
    end

    private
    
    def list_params
      params[:recurring_list].permit(:user_id, recurring_list_items: [:variant_id, :quantity])
    end

  end
end
