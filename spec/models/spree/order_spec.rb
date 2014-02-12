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

end
