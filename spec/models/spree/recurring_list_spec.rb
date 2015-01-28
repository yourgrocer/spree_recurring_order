require 'spec_helper'

describe Spree::RecurringOrder do

  describe 'creation' do

    it 'should have many list items' do
      user = FactoryGirl.create(:user)

      item = Spree::RecurringListItem.create
      list = Spree::RecurringList.new(user: user)
      list.items << item
      list.save!
    end

  end

  describe 'validation' do

    it 'should require a user' do
      list = Spree::RecurringList.new
      expect(list.valid?).to be_false
      expect(list.errors[:user]).not_to be_empty
    end

  end

end
