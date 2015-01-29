require 'spec_helper'

describe Spree::RecurringListItem do

  describe 'validation' do

    it 'should not be valid without quantity' do
      item = Spree::RecurringListItem.new
      expect(item).not_to be_valid
      expect(item.errors[:quantity]).not_to be_empty
    end

    it 'should not be valid with text quantity' do
      item = Spree::RecurringListItem.new(quantity: 'blah')
      expect(item).not_to be_valid
      expect(item.errors[:quantity]).not_to be_empty
    end

    it 'should not be valid if it does not have a variant' do
      item = Spree::RecurringListItem.new()
      expect(item).not_to be_valid
      expect(item.errors[:variant]).not_to be_empty
    end

  end

end

