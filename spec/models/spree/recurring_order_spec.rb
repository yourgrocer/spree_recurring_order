require 'spec_helper'

describe Spree::RecurringOrder do

  it 'should be able to create a recurring order' do
    Spree::RecurringOrder.create.should be_true
  end

end
