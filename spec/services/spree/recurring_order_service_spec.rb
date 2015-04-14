require 'spec_helper'

describe Spree::RecurringOrderService do

  describe 'create orders' do

    let(:base_list){double(Spree::RecurringList).as_null_object}
    let(:userA){double(Spree::Order, has_incomplete_order_booked?: false).as_null_object}
    let(:orderA){double(Spree::Order, user: userA).as_null_object}
    let(:orderB){double(Spree::Order, user: userA).as_null_object}
    let(:mail){double(Object).as_null_object}
    let(:join_statement){double(Object).as_null_object}

    before :each do
      allow(orderA).to receive(:base_list).and_return base_list
      allow(orderB).to receive(:base_list).and_return base_list
      allow(Spree::RecurringOrderProcessingMailer).to receive(:results_email).and_return mail
      allow(Spree::RecurringOrder).to receive(:joins).and_return(join_statement)
    end

    it 'should create all orders for delivery in two days from now' do
      allow(join_statement).to receive(:where).and_return([orderA, orderB])

      expect(orderA).to receive(:create_order_from_base_list)
      expect(orderB).to receive(:create_order_from_base_list)

      service = Spree::RecurringOrderService.new(Date.today)
      service.create_orders
    end

    it 'should not create order if recurring list is empty' do
      allow(join_statement).to receive(:where).and_return([orderA, orderB])
      allow(Spree::RecurringOrder).to receive(:where).and_return([orderA, orderB])
      allow(orderB).to receive(:base_list).and_return nil

      expect(orderA).to receive(:create_order_from_base_list)
      expect(orderB).not_to receive(:create_order_from_base_list)

      service = Spree::RecurringOrderService.new(Date.today)
      service.create_orders
    end

    it 'should not create orders for other dates' do
      allow(join_statement).to receive(:where).with(spree_recurring_lists: {next_delivery_date: Date.today + 2.days}).and_return([])

      service = Spree::RecurringOrderService.new(Date.today)
      service.create_orders
    end

    it 'should not create order if user has another order with delivery date set' do
      allow(join_statement).to receive(:where).and_return([orderA, orderB])
      allow(userA).to receive(:has_incomplete_order_booked?).and_return true

      expect(orderA).not_to receive(:create_order_from_base_list)

      service = Spree::RecurringOrderService.new(Date.today)
      service.create_orders
    end

    it 'should keep processing if one of the orders fail' do
      allow(join_statement).to receive(:where).and_return([orderA, orderB])

      expect(orderA).to receive(:create_order_from_base_list).and_raise(RuntimeError)
      expect(orderB).to receive(:create_order_from_base_list)

      service = Spree::RecurringOrderService.new(Date.today)
      service.create_orders
    end

    it 'should store outcomes' do
      allow(join_statement).to receive(:where).and_return([orderA, orderB])
      allow(orderA).to receive(:create_order_from_base_list).and_raise(RuntimeError)

      expect(Spree::RecurringOrderProcessingOutcome).to receive(:new).with(orderA, anything, instance_of(RuntimeError))
      expect(Spree::RecurringOrderProcessingOutcome).to receive(:new).with(orderB, anything, nil)

      service = Spree::RecurringOrderService.new(Date.today)
      service.create_orders
    end

    it 'should send email with results' do
      allow(join_statement).to receive(:where).and_return([orderA, orderB])
      expect(Spree::RecurringOrderProcessingMailer).to receive(:results_email)

      service = Spree::RecurringOrderService.new(Date.today)
      service.create_orders
    end

  end

end
