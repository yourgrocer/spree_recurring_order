module Spree
  class RecurringOrderService

    def initialize(date)
      @date = date
    end

    def create_and_complete_orders
      orders = Spree::RecurringOrder.joins(:recurring_lists).where(spree_recurring_lists: {next_delivery_date: @date + 3.days})

      results = []
      orders.each do |recurring_order|
        puts "processing #{recurring_order.number}"
        exception = nil
        new_order = nil
        begin
          raise Spree::RecurringOrderProcessingError.new("Order is paused") unless recurring_order.active?
          raise Spree::RecurringOrderProcessingError.new("Order doesn't have a base list") unless recurring_order.base_list
          raise Spree::RecurringOrderProcessingError.new("User has another booked incomplete order") if recurring_order.user.has_incomplete_order_booked?

          incomplete_order_for_tomorrow = recurring_order.has_incomplete_order_on(Date.tomorrow)
          incomplete_order_for_today = recurring_order.has_incomplete_order_on(Date.today)

          order = if recurring_order.for(:tomorrow_morning) && incomplete_order_for_tomorrow
            incomplete_order_for_tomorrow
          elsif recurring_order.for(:today_morning) && incomplete_order_for_today
            incomplete_order_for_today
          elsif recurring_order.for(:today_evening) && incomplete_order_for_today
            incomplete_order_for_today
          else
            new_order = recurring_order.create_order_from_base_list
            raise Spree::RecurringOrderProcessingError.new("Order creation failed - #{new_order.errors.full_messages.first}") unless new_order.valid?
            new_order
          end

          offline_payment = Spree::PaymentMethod.find_by(name: "Admin - Offline Payment")
          order.complete(offline_payment)
          raise Spree::RecurringOrderProcessingError.new("Order has not been completed") unless order.state != 'complete'
        rescue => e
          exception = e
        ensure
          results << Spree::RecurringOrderProcessingOutcome.new(recurring_order, new_order, exception)
        end
      end

      Spree::RecurringOrderProcessingMailer.results_email(results, @date).deliver
    end

  end
end
