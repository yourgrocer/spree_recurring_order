module Spree
  class RecurringOrderProcessingOutcome

    def initialize(order, exception=nil)
      @order = order
      @exception = exception
    end

    def order_number
      @order.number
    end

    def email
      @order.email
    end

    def success
      @exception.nil?
    end

    def message
      if @exception.nil? 
        "Created for delivery on #{@order.delivery_date.strftime("%d/%m/%Y")} from #{@order.delivery_time}"
      else
        "Processing failed - #{@exception.message}"
      end
    end

  end
end
