require 'spec_helper'

describe Spree::RecurringOrderService do

  describe 'create orders' do

    let(:base_list){double(Spree::RecurringList).as_null_object}
    let(:userA){double(Spree::Order, has_incomplete_order_booked?: false).as_null_object}
    let(:orderA){double(Spree::Order, user: userA).as_null_object}
    let(:orderB){double(Spree::Order, user: userA).as_null_object}

    before :each do
      allow(orderA).to receive(:base_list).and_return base_list
      allow(orderB).to receive(:base_list).and_return base_list
    end

    it 'should create all orders for delivery in two days from now' do
      allow(Spree::RecurringOrder).to receive(:where).and_return([orderA, orderB])

      expect(orderA).to receive(:create_order_from_base_list)
      expect(orderB).to receive(:create_order_from_base_list)

      service = Spree::RecurringOrderService.new(Date.today)
      service.create_orders
    end

    it 'should not create order if recurring list is empty' do
      allow(Spree::RecurringOrder).to receive(:where).and_return([orderA, orderB])
      allow(orderB).to receive(:base_list).and_return nil

      expect(orderA).to receive(:create_order_from_base_list)
      expect(orderB).not_to receive(:create_order_from_base_list)

      service = Spree::RecurringOrderService.new(Date.today)
      service.create_orders
    end

    it 'should not create orders for other dates' do
      expect(Spree::RecurringOrder).to receive(:where).with(next_delivery_date: Date.today + 2.days).and_return([])

      service = Spree::RecurringOrderService.new(Date.today)
      service.create_orders
    end

    it 'should not create order if user has another order with delivery date set' do
      allow(Spree::RecurringOrder).to receive(:where).and_return([orderA, orderB])
      allow(userA).to receive(:has_incomplete_order_booked?).and_return true

      expect(orderA).not_to receive(:create_order_from_base_list)

      service = Spree::RecurringOrderService.new(Date.today)
      service.create_orders
    end

    it 'should keep processing if one of the orders fail' do
      allow(Spree::RecurringOrder).to receive(:where).and_return([orderA, orderB])

      expect(orderA).to receive(:create_order_from_base_list).and_raise(RuntimeError)
      expect(orderB).to receive(:create_order_from_base_list)

      service = Spree::RecurringOrderService.new(Date.today)
      service.create_orders
    end
    it 'should send email with results'

  end

end
