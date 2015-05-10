module Spree
  class RecurringOrder < ActiveRecord::Base
    define_model_callbacks :create_order, only: [:after, :before]

    validate :at_least_one_order_or_list

    has_many :orders
    has_many :recurring_lists

    belongs_to :original_order, class_name: 'Spree::Order'

    after_create :generate_order_number

    def self.create_from_order(order)
      recurring_order = RecurringOrder.new
      recurring_order.orders << order
      recurring_order.save!
      recurring_order
    end

    def create_order_from_base_list
      run_callbacks :create_order do
        @new_order = Spree::Order.new
        @new_order.recurring_order = self
        @new_order.email = base_list.user.email
        @new_order.created_by = base_list.user
        @new_order.user = base_list.user

        @new_order.ship_address = ship_address(base_list)
        @new_order.bill_address = bill_address(base_list)

        set_new_order_extended_values(@new_order)

        if @new_order.save
          @new_order.merge!(order_to_merge) if (order_to_merge && order_to_merge != @new_order)
          order_contents = Spree::OrderContents.new(@new_order)
          base_list.items.each do |item|
            order_contents.add(item.variant, item.quantity, quick_add: true)
          end
          move_order_to_payment_state(@new_order)
        end
        @new_order
      end
    end

    def user
      @user ||= recurring_lists.empty? ? nil : recurring_lists.first.user
    end

    def base_list
      @base_list ||= recurring_lists.sort_by{|list| list.created_at}.first
    end

    def original_order
      @original_order ||= orders.sort_by{|order| order.created_at}.first
    end

    def ship_address(base_list)
      base_list.user.orders.complete.last.ship_address.dup
    end

    def bill_address(base_list)
      base_list.user.orders.complete.last.bill_address.dup
    end

    def email
      base_list.nil? ? original_order.email : base_list.user.email
    end

    def phone
      original_order.ship_address.phone rescue 'N/A'
    end

    private

    def order_to_merge
      @order_to_merge ||= base_list.nil? ? nil : base_list.user.last_incomplete_spree_order
      @order_to_merge
    end

    def move_order_to_payment_state(order)
      counter = 0
      while order.state != 'payment'
        order.next
        counter = counter + 1
        break if counter > 3
      end
    end

    def set_new_order_extended_values(order)
      #To be overriden
    end

    def at_least_one_order_or_list
      if orders.empty? && recurring_lists.empty?
        self.errors[:base] << "recurring order needs a order or a recurring list"
      end
    end

    def generate_order_number
      record = true
      while record
        random = "RO#{Array.new(9){rand(9)}.join}"
        record = self.class.where(number: random).first
      end
      self.number = random if self.number.blank?
      self.number
      self.save!
    end

  end
end
