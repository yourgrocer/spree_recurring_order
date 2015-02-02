require 'spec_helper'

describe Spree::RecurringOrder do

  describe 'validation' do

    it 'should require a user' do
      list = Spree::RecurringList.new
      expect(list.valid?).to be_falsey
      expect(list.errors[:user]).not_to be_empty
    end

    it 'should not valid without any items' do
      list = Spree::RecurringList.new
      expect(list.valid?).to be_falsey
      expect(list.errors[:items]).not_to be_empty
    end

  end

end
