require 'spec_helper'

describe Spree::RecurringOrder do

  describe 'creation' do

    it 'should have many list items' do
      user = FactoryGirl.create(:user)
      variant = FactoryGirl.create(:variant)

      item = Spree::RecurringListItem.create(variant_id: variant.id, quantity: 1)
      list = Spree::RecurringList.new(user: user)
      list.items << item
      list.save!
    end

  end

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