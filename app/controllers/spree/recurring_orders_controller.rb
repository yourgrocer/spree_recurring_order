module Spree
  class RecurringOrdersController < Spree::StoreController

    def create
      original_order = Spree::Order.find(recurring_order_params[:original_order_id])
      if original_order.recurring_order.nil?
        @recurring_order = Spree::RecurringOrder.new
        @recurring_order.orders << original_order

        if @recurring_order.save
          redirect_to(spree.recurring_order_url(@recurring_order.id))
        else
          flash[:notice] = "Hmmm... There was a problem creating your regular order. Please get in touch at hello@yourgrocer.com.au and we are going to sort it out for you."
          redirect_to(order_url(original_order.number))
        end
      else
        flash[:notice] = "Hmmm... It seems like this order already has a regular order associated with it. Please get in touch at hello@yourgrocer.com.au if you have any doubts about it"
        redirect_to(order_url(original_order.number))
      end
    end

    def update
      @recurring_order = Spree::RecurringOrder.find(params[:id])
      @recurring_order.update_attributes(update_params)
      render :nothing => true, :status => 200, :content_type => 'text/html'
    end

    def show
      @recurring_order = Spree::RecurringOrder.find(params[:id])
    end

    private

    def recurring_order_params
      params[:recurring_order].permit(:original_order_id)
    end

    def update_params
      params[:recurring_order].permit(:active)
    end

  end
end
