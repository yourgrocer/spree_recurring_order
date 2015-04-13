module Spree
  class RecurringOrderService

    def initialize(date)
      @date = date
    end

    def create_orders
      orders = Spree::RecurringOrder.where(next_delivery_date: @date + 2.days)
      orders = orders.reject{|order| order.base_list.nil?}
      orders = orders.reject{|order| order.user.has_incomplete_order_booked? }

      orders.each do |order|
        begin
          order.create_order_from_base_list
        rescue
        end
      end

    end

  end
end
