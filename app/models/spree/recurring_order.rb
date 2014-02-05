module Spree
  class RecurringOrder < ActiveRecord::Base

    belongs_to :original_order, class_name: 'Spree::Order'

    def self.create_from_order(order)
      recurring_order = RecurringOrder.new
      recurring_order.original_order = order
      recurring_order.save!
      recurring_order
    end

  end
end
