require 'spec_helper'

describe Spree::RecurringOrder do

  describe 'update next delivery date' do

    it 'should move next delivery date to 7 days later if existing' do
      list = FactoryGirl.create(:recurring_list, next_delivery_date: Date.today)
      list.update_next_delivery_date!
      expect(list.reload.next_delivery_date).to eq(Date.today + 7.days)
    end

  end

  describe 'validation' do

    it 'should require a user' do
      list = Spree::RecurringList.new
      expect(list.valid?).to be_falsey
      expect(list.errors[:user]).not_to be_empty
    end

  end

  describe 'remove_item' do

    it 'should remove item' do
      list = FactoryGirl.create(:recurring_list)
      item = list.items.first
      expect(list.remove_item(id: item.id)).to be_truthy
      expect(list.items.reload).to be_empty
    end

    it 'should fail if item doesnt exist' do
      list = FactoryGirl.create(:recurring_list)
      expect(list.remove_item(id: 666)).to be_falsey
      expect(list.items.reload).not_to be_empty
    end

  end

  describe 'add_item' do

    it 'should add item if it doesnt exist' do
      list = FactoryGirl.create(:recurring_list)
      result = list.add_item(variant_id: 1, quantity: 2)

      expect(list.items.empty?).to be_falsey
      expect(list.items.last.variant_id).to eq(1)
      expect(list.items.last.quantity).to eq(2)
      expect(result).to eq(list.items.last)
    end

    it 'should update item if it exists' do
      list = FactoryGirl.create(:recurring_list)
      variant_id = list.items.first.variant_id
      quantity = list.items.first.quantity

      result = list.add_item(variant_id: variant_id, quantity: 99)

      expect(list.items.size).to eq(1)
      expect(list.items.last.variant_id).to eq(variant_id)
      expect(list.items.last.quantity).to eq(99 + quantity)
      expect(result).to eq(list.items.first)
    end

    it 'should fail and not update if variant_id is invalid' do
      list = FactoryGirl.create(:recurring_list)
      result = list.add_item(variant_id: '666', quantity: 99)
      expect(result).to be_nil
      expect(list.items.size).to eq(1)
    end

    it 'should fail and not update if quantity is invalid' do
      list = FactoryGirl.create(:recurring_list)
      expect(list.add_item(variant_id: '666', quantity: -1)).to be_falsey
      expect(list.items.size).to eq(1)
    end

  end

end
