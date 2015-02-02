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

  describe 'add_item' do

    it 'should add item if it doesnt exist' do
      list = Spree::RecurringList.new
      list.add_item(variant_id: 1, quantity: 2)

      expect(list.items.empty?).to be_falsey
      expect(list.items.last.variant_id).to eq(1)
      expect(list.items.last.quantity).to eq(2)
    end

    it 'should update item if it exists'
    it 'should fail and not update if variant_id is invalid'
    it 'should fail and not update if quantity is invalid'

  end

end
