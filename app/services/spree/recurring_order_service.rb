module Spree
  class RecurringOrderService

    def initialize(date)
      @date = date
    end

    def create_orders
      orders = Spree::RecurringOrder.joins(:recurring_lists).where(spree_recurring_lists: {next_delivery_date: @date + 2.days})

      results = []
      orders.each do |recurring_order|
        exception = nil
        new_order = nil
        begin
          raise Spree::RecurringOrderProcessingError.new("Order is paused") unless recurring_order.active?
          raise Spree::RecurringOrderProcessingError.new("Order doesn't have a base list") unless recurring_order.base_list
          raise Spree::RecurringOrderProcessingError.new("User has another booked incomplete order") if recurring_order.user.has_incomplete_order_booked?
          new_order = recurring_order.create_order_from_base_list

          raise Spree::RecurringOrderProcessingError.new("Order creation failed - #{new_order.errors.full_messages.first}") unless new_order.valid?
        rescue => e
          exception = e
        ensure
          results << Spree::RecurringOrderProcessingOutcome.new(recurring_order, new_order, exception)
        end
      end
 
      Spree::RecurringOrderProcessingMailer.results_email(results, @date)
    end

  end
end
