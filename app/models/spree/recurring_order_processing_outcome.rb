module Spree
  class RecurringOrderProcessingOutcome

    def initialize(recurring_order, new_order, exception=nil)
      @recurring_order = recurring_order
      @exception = exception
      @new_order = new_order
    end

    def recurring_order_number
      @recurring_order.number
    end

    def order_number
      @new_order.nil? ? nil : @new_order.number
    end

    def email
      @recurring_order.email
    end

    def success
      @exception.nil?
    end

    def message
      if @exception.nil? 
        "Created for delivery on #{@new_order.delivery_date.strftime("%d/%m/%Y")} from #{@new_order.delivery_time}"
      else
        "Processing failed - #{@exception.message}"
      end
    end

  end
end
