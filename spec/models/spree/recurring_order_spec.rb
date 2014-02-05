require 'spec_helper'

describe Spree::RecurringOrder do

  describe 'create from order' do

    it 'should create from original order' do
      order = FactoryGirl.create(:order)

      recurring_order = Spree::RecurringOrder.create_from_order(order)
      recurring_order.id.should_not be_nil
    end

    it 'should set original order' do
      order = FactoryGirl.create(:order)

      recurring_order = Spree::RecurringOrder.create_from_order(order)
      recurring_order.original_order.should == order
    end

  end

  describe 'validation' do

    it 'should have at least one order' do
     recurring_order = Spree::RecurringOrder.new
     recurring_order.should_not be_valid
     recurring_order.errors[:orders].should_not be_empty
    end

    it 'should be valid with one order' do
      order = FactoryGirl.build(:order)
      recurring_order = Spree::RecurringOrder.new
      recurring_order.orders << order
      recurring_order.should be_valid
    end

  end

end
