require 'spec_helper'

describe Spree::RecurringOrder do

  describe 'create from order' do

    it 'should create from original order' do
      order = FactoryGirl.create(:order)

      recurring_order = Spree::RecurringOrder.create_from_order(order)
      recurring_order.id.should_not be_nil
    end

  end

end
