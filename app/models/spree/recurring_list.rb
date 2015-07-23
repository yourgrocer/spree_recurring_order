module Spree
  class RecurringList < ActiveRecord::Base
    CREATE_TIMESPAN   = 1.days
    COMPLETE_TIMESPAN = 0.day

    belongs_to :user
    belongs_to :recurring_order, :dependent => :destroy
    has_many :items, class_name: 'Spree::RecurringListItem'
    accepts_nested_attributes_for :items

    validates :user, presence: true
    validates :next_delivery_date, presence: true
    validates :timeslot, presence: true

    after_create :generate_api_key_if_not_present

    scope :to_create, lambda { |date|
      where next_delivery_date: (date + CREATE_TIMESPAN)
    }
    scope :to_complete, lambda { |date|
      where next_delivery_date: date..(date + COMPLETE_TIMESPAN)
    }

    def self.build_from_order(order)
      recurring_list = Spree::RecurringList.new
      recurring_list.user_id = order.user.id
      recurring_list.timeslot = order.delivery_time
      recurring_list.next_delivery_date = order.delivery_date + 7.days
      recurring_list.items = order.line_items.map{|line_item| Spree::RecurringListItem.from_line_item(line_item)}
      recurring_list
    end

    def update_next_delivery_date!
      update_attributes(next_delivery_date: next_delivery_date + 7.days)
    end

    def remove_item(item_params)
      item = items.where(item_params).first
      item.nil? ? false : item.destroy
    end

    def set_valid_next_delivery_date!
      return if next_delivery_date > (Time.zone.now.to_date + CREATE_TIMESPAN)

      update_next_delivery_date!
    end

    def add_item(item_params)
      return nil unless Spree::Variant.find_by(id: item_params[:variant_id])

      updated_item = items.select{|item| item.variant_id == item_params[:variant_id].to_i}.first
      if updated_item
        updated_item.update_attributes(quantity: item_params[:quantity].to_i)
      else
        updated_item = Spree::RecurringListItem.new(item_params)
        self.items << updated_item
      end

      self.save
      updated_item
    end

    private

    def generate_api_key_if_not_present
      user.generate_spree_api_key! if user.spree_api_key.nil?
    end
  end
end
