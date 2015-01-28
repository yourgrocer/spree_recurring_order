module Spree
  class RecurringList < ActiveRecord::Base
    belongs_to :user
    has_many :items, class_name: 'Spree::RecurringListItem'

    validates :user, presence: true
  end
end
