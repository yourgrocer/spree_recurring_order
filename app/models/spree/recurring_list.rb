module Spree
  class RecurringList < ActiveRecord::Base
    belongs_to :user
    has_many :items, class_name: 'Spree::RecurringListItem'
    accepts_nested_attributes_for :items

    validates :user, presence: true
    validate :items_present

    private

    def items_present
      if items.empty?
        errors[:items] << "are empty. Please add at least one item to your regular order"
      end
    end
  end
end
