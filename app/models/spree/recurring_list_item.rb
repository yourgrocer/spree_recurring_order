module Spree
  class RecurringListItem < ActiveRecord::Base
    belongs_to :recurring_list
    belongs_to :variant, class_name: 'Spree::Variant'
  end
end
