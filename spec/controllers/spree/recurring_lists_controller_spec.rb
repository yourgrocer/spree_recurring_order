require 'spec_helper'

describe Spree::RecurringListsController do

  let(:user) { double Spree::User, :last_incomplete_spree_order => nil, :has_spree_role? => true, :spree_api_key => 'fake' }

  before :each do
    controller.stub :spree_current_user => user
    controller.stub :check_authorization

    allow(Spree::User).to receive(:find).and_return(user)
  end

  describe 'integration' do

    it 'should create new recurring list (integration)' do
      variant = FactoryGirl.create(:variant)
      new_user = FactoryGirl.create(:user)
      params = {"recurring_list" => {"user_id" => new_user.id, "items_attributes" => {
        "0"=>{"variant_id"=>variant.id, "quantity"=>"1", "id"=>"108284", "selected"=>"1"}, 
      }}}
      spree_post :create, params

      recurring_list = Spree::RecurringList.last
      expect(recurring_list.user).to eq(new_user)
      expect(recurring_list.items.count).to eq(1)

      list_item = recurring_list.items.first
      expect(list_item.variant).to eq(variant)
      expect(list_item.quantity).to eq(1)
    end

  end

  describe 'create' do

    let(:list_item) { double Spree::RecurringListItem }
    let(:list_items) { double "MyArray" }
    let(:list) { double(Spree::RecurringList, items: list_items) }

    before :each do
      allow(Spree::RecurringList).to receive(:new).and_return(list)
      allow(list).to receive(:save).and_return true
    end

    it 'should create list for provided user' do
      expect(Spree::RecurringList).to receive(:new).with(hash_including(user_id: '1'))
      spree_post :create, recurring_list: {user_id: 1, recurring_list_items: []}
    end

    it 'should add list items to list based' do
      expect(Spree::RecurringList).to receive(:new).with(hash_including({
        "items_attributes" => [
          {"variant_id"=>"4953", "quantity"=>"3"}
        ]
      }))

      params = {"recurring_list" => {"user_id" => 2, "items_attributes" => {
        "0"=>{"variant_id"=>"7584", "quantity"=>"1", "id"=>"108284", "selected" => '0'}, 
        "1"=>{"variant_id"=>"4953", "quantity"=>"3", "id"=>"108285", "selected" => '1'}
      }}}
      spree_post :create, params 
    end

    it 'should fail and render error if recurring list is not valid' do
      expect(list).to receive(:save).and_return false
      spree_post :create, recurring_list: {user_id: 1, recurring_list_items: []}
      expect(response.status).to eq(400)
    end

    it 'should redirect to my account after creation' do
      spree_post :create, recurring_list: {user_id: 1, recurring_list_items: []}
      expect(response).to redirect_to('/account')
    end

  end

end
