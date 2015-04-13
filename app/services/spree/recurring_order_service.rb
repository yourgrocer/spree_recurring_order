module Spree
  class RecurringOrderService

    def initialize(date)
      @date = date
    end

    def create_orders
      orders = Spree::RecurringOrder.where(next_delivery_date: @date + 2.days)
      orders = orders.reject{|order| order.base_list.nil?}
      orders = orders.reject{|order| order.user.has_incomplete_order_booked? }

      results = []
      orders.each do |order|
        exception = nil
        begin
          order.create_order_from_base_list
        rescue => e
          exception = e
        ensure
          results << Spree::RecurringOrderProcessingOutcome.new(order, exception)
        end
      end
  
      Spree::OrderMailer.recurring_orders_processing_email(results).deliver!
    end

  end
end
