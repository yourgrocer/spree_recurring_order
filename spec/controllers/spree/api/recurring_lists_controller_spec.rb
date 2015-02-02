require 'spec_helper'

describe Spree::Api::RecurringListsController do

  let(:user) { mock_model Spree::User, id: 1, :last_incomplete_spree_order => nil, :has_spree_role? => true, :spree_api_key => 'fake' }

  before :each do
    controller.stub :spree_current_user => user
  end

  describe 'integration' do

    it 'should update list' do
      variant = FactoryGirl.create(:variant)
      list = FactoryGirl.create(:recurring_list)

      api_put :update, id: list.id, recurring_list_item: {variant_id: variant.id, quantity: 3}

      expect(response.status).to eq(201)
      expect(list.reload.items.map{|item| item.variant_id}).to include(variant.id)
    end

  end

  describe 'updating items' do

    let(:recurring_list){FactoryGirl.build(:recurring_list)}

    it 'should update item from the list' do
      allow(Spree::RecurringList).to receive(:find).with(1).and_return(recurring_list)
      expect(recurring_list).to receive(:add_item).with("variant_id" => 123, "quantity" => 3).and_return(true)

      api_put :update, id: 1, recurring_list_item: {variant_id: 123, quantity: 3}
      expect(response.status).to eq(201)
    end

    it 'should fail if recurring list is not found' do
      api_put :update, id: 3, recurring_list_item: {variant_id: 123, quantity: 3}
      expect(response.status).to eq(404)
    end

    it 'should not allow update if user doesnt own recurring list' do
      new_user = double(Spree::User, id: 3, :last_incomplete_spree_order => nil, :has_spree_role? => true, :spree_api_key => 'fake')
      allow(controller).to receive(:spree_current_user).and_return(new_user)

      other_recurring_list = FactoryGirl.build(:recurring_list, user_id: 4)
      allow(Spree::RecurringList).to receive(:find).with(1).and_return(other_recurring_list)
      expect(recurring_list).not_to receive(:add_item)

      api_put :update, id: 1, recurring_list_item: {variant_id: 123, quantity: 3}
      expect(response.status).to eq(401)
    end

    it 'should not allow update if user is not logged in' do
      allow(controller).to receive(:spree_current_user).and_return(nil)

      other_recurring_list = FactoryGirl.build(:recurring_list, user_id: 4)
      allow(Spree::RecurringList).to receive(:find).with(1).and_return(other_recurring_list)
      expect(recurring_list).not_to receive(:add_item)

      api_put :update, id: 1, recurring_list_item: {variant_id: 123, quantity: 3}
      expect(response.status).to eq(401)
    end

  end

end
