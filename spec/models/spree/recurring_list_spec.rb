require 'spec_helper'

describe Spree::RecurringOrder do

  describe 'creation' do

    it 'should have many list items' do
      item = Spree::RecurringListItem.create!
      list = Spree::RecurringList.new
      list.items << item
      list.save!
    end

  end

end
