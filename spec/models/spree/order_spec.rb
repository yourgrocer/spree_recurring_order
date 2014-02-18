require 'spec_helper'

describe Spree::Order do

  describe 'recurring?' do

    it 'should be false if order doesnt have a recurring one' do
      order = Spree::Order.new
      order.recurring?.should be_false
    end

    it 'should be true if order has a recurring one' do
      order = Spree::Order.new
      order.recurring_order = Spree::RecurringOrder.new
      order.recurring?.should be_true
    end

  end

  describe 'deliver recurring order email' do

    it 'should not deliver anything if order is not recurring' do
      order = Spree::Order.new
      order.stub(:recurring?).and_return false
      order.deliver_recurring_order_email

      Spree::OrderMailer.should_not_receive(:recurring_email)
    end

    it 'should deliver if order is recurring' do
      order = Spree::Order.new
      order.stub(:id).and_return 2
      order.stub(:recurring?).and_return true

      mail = double(Object)
      Spree::OrderMailer.should_receive(:recurring_email).with(2).and_return(mail)
      mail.should_receive(:deliver)

      order.deliver_recurring_order_email
    end

  end

end
