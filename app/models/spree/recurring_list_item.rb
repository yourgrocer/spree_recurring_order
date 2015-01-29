module Spree
  class RecurringListItem < ActiveRecord::Base
    belongs_to :recurring_list
    belongs_to :variant, class_name: 'Spree::Variant'

    validates :quantity, presence: true, numericality: true
    validates :variant, presence: true

    attr_reader :selected

    def self.from_line_item(line_item)
      recurring_list_item = Spree::RecurringListItem.new
      recurring_list_item.variant_id = line_item.variant_id
      recurring_list_item.quantity = line_item.quantity
      recurring_list_item
    end

  end
end
