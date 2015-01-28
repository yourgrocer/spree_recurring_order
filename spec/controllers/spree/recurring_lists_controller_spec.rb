require 'spec_helper'

describe Spree::RecurringListsController do

  let(:user) { mock_model Spree::User, :last_incomplete_spree_order => nil, :has_spree_role? => true, :spree_api_key => 'fake' }

  before :each do
    controller.stub :spree_current_user => user
    controller.stub :check_authorization
  end

  describe 'integration' do

    it 'should create new recurring list (integration)' do
      variant = FactoryGirl.create(:variant)
      new_user = FactoryGirl.create(:user)
      spree_post :create, recurring_list: {user_id: new_user.id, recurring_list_items: [variant_id: variant.id, quantity: 1]}

      recurring_list = Spree::RecurringList.last
      expect(recurring_list.user).to eq(new_user)
      expect(recurring_list.items.count).to eq(1)

      list_item = recurring_list.items.first
      expect(list_item.variant).to eq(variant)
      expect(list_item.quantity).to eq(1)
    end

  end

  describe 'create' do

    let(:list_item) { mock_model Spree::RecurringListItem }
    let(:list_items) { mock_model "MyArray" }
    let(:list) { mock_model(Spree::RecurringList, items: list_items).as_null_object }

    before :each do
      allow(Spree::RecurringList).to receive(:new).and_return(list)
    end

    it 'should create list for provided user' do
      expect(Spree::RecurringList).to receive(:new).with(hash_including(user_id: '1'))
      spree_post :create, recurring_list: {user_id: 1, recurring_list_items: []}
    end

    it 'should add list items to list based' do
      expect(Spree::RecurringListItem).to receive(:new).with(variant_id: '1', quantity: '2').and_return(list_item)
      expect(list_items).to receive(:<<).with(list_item)

      spree_post :create, recurring_list: {user_id: 1, recurring_list_items: [{variant_id: 1, quantity: 2}]}
    end

    it 'should fail and render error if recurring list is not valid'
    it 'should redirect to my account after creation'

  end

end
