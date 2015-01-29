module Spree
  class RecurringListItem < ActiveRecord::Base
    belongs_to :recurring_list
    belongs_to :variant, class_name: 'Spree::Variant'

    validates :quantity, presence: true, numericality: true
    validates :variant, presence: true
  end
end
