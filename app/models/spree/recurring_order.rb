module Spree
  class RecurringOrder < ActiveRecord::Base

    has_many :orders

    belongs_to :original_order, class_name: 'Spree::Order'

    def self.create_from_order(order)
      recurring_order = RecurringOrder.new
      recurring_order.orders << order
      recurring_order.save!
      recurring_order
    end

    def original_order
      orders.sort_by{|order| order.created_at}.first
    end

  end
end
