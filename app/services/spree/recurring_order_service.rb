module Spree
  class RecurringOrderService

    def initialize(date)
      @date = date
    end

    def create_orders
      orders = Spree::RecurringOrder.where(next_delivery_date: @date + 2.days)

      results = []
      orders.each do |order|
        exception = nil
        begin
          raise RecurringOrderProcessingError.new("Order doesn't have a base list") unless order.base_list
          raise RecurringOrderProcessingError.new("User has another booked incomplete order") if order.user.has_incomplete_order_booked?
          order.create_order_from_base_list
        rescue => e
          exception = e
        ensure
          results << Spree::RecurringOrderProcessingOutcome.new(order, exception)
        end
      end
  
      Spree::OrderMailer.recurring_orders_processing_email(results, @date).deliver!
    end

  end
end
