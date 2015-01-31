module Spree
  class RecurringListItemsController < Spree::StoreController

    def destroy
      Spree::RecurringListItem.find(params[:id]).destroy!
      respond_to do |format|
        format.html {redirect_to account_url}
        format.json {render json: 'OK'}
      end
      
    end
  end
end
