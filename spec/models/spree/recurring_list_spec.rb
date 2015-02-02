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
      list = FactoryGirl.create(:recurring_list) 
      expect(list.add_item(variant_id: 1, quantity: 2)).to be_truthy

      expect(list.items.empty?).to be_falsey
      expect(list.items.last.variant_id).to eq(1)
      expect(list.items.last.quantity).to eq(2)
    end

    it 'should update item if it exists' do
      list = FactoryGirl.create(:recurring_list) 
      variant_id = list.items.first.variant_id
      quantity = list.items.first.quantity

      expect(list.add_item(variant_id: variant_id, quantity: 99)).to be_truthy

      expect(list.items.size).to eq(1) 
      expect(list.items.last.variant_id).to eq(variant_id)
      expect(list.items.last.quantity).to eq(99 + quantity)
    end

    it 'should fail and not update if variant_id is invalid' do
      list = FactoryGirl.create(:recurring_list) 
      expect(list.add_item(variant_id: '666', quantity: 99)).to be_falsey
      expect(list.items.size).to eq(1) 
    end

    it 'should fail and not update if quantity is invalid' do
      list = FactoryGirl.create(:recurring_list) 
      expect(list.add_item(variant_id: '666', quantity: -1)).to be_falsey
      expect(list.items.size).to eq(1) 
    end

  end

end
