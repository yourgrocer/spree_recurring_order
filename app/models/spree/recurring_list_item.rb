module Spree
  class RecurringListItem < ActiveRecord::Base
    belongs_to :recurring_list
    has_one :variant
  end
end
