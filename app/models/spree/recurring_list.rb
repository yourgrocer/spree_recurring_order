module Spree
  class RecurringList < ActiveRecord::Base
    belongs_to :user
    belongs_to :recurring_order, :dependent => :destroy
    has_many :items, class_name: 'Spree::RecurringListItem'
    accepts_nested_attributes_for :items

    validates :user, presence: true
    validates :next_delivery_date, presence: true
    validates :timeslot, presence: true
    validate :items_present

    def self.build_from_order(order)
      recurring_list = Spree::RecurringList.new
      recurring_list.user_id = order.user.id
      recurring_list.timeslot = order.delivery_time
      recurring_list.next_delivery_date = order.delivery_date + 7.days
      recurring_list.items = order.line_items.map{|line_item| Spree::RecurringListItem.from_line_item(line_item)}
      recurring_list
    end

    def add_item(item_params)
      return false unless Spree::Variant.find_by(id: item_params[:variant_id])

      existing_item = items.select{|item| item.variant_id == item_params[:variant_id].to_i}.first
      if existing_item
        existing_item.update_attributes(quantity: existing_item.quantity + item_params[:quantity].to_i)
      else
        self.items << Spree::RecurringListItem.new(item_params)
      end
      self.save
    end

    private

    def items_present
      if items.empty?
        errors[:items] << "are empty. Please add at least one item to your regular order"
      end
    end
  end
end
