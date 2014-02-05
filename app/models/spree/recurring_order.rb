module Spree
  class RecurringOrder < ActiveRecord::Base

    validate :at_least_one_order

    has_many :orders

    belongs_to :original_order, class_name: 'Spree::Order'

    def self.create_from_order(order)
      recurring_order = RecurringOrder.new
      recurring_order.orders << order
      recurring_order.save!
      recurring_order
    end

    def original_order
      @original_order ||= orders.sort_by{|order| order.created_at}.first
    end

    def email
      original_order.email
    end

    def phone
      original_order.ship_address.phone rescue ''
    end

    private

    def at_least_one_order
      self.errors[:orders] << "cannot be empty" if orders.empty?
    end

  end
end
