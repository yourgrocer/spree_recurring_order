require 'spec_helper'

describe Spree::Api::RecurringListsController do

  let(:roles) {mock_model 'Roles', pluck: []}
  let(:user) { mock_model Spree::User, id: 1, :last_incomplete_spree_order => nil, :has_spree_role? => true, :spree_api_key => 'fake', :spree_roles => roles}

  before :each do
    stub_authentication!
    controller.class.skip_before_filter :verify_logged_in_user
  end

  def current_api_user
    user
  end

  describe 'integration' do

    it 'should update list' do
      variant = FactoryGirl.create(:variant)
      list = FactoryGirl.create(:recurring_list, user: user)

      api_put :update, id: list.id, recurring_list_item: {variant_id: variant.id, quantity: 3}, token: 'fake'

      expect(response.status).to eq(200)
      expect(list.reload.items.map{|item| item.variant_id}).to include(variant.id)
    end

  end

  describe 'updating items' do

    let(:recurring_order){FactoryGirl.build(:recurring_order)}
    let(:recurring_list){FactoryGirl.build(:recurring_list, recurring_order: recurring_order, user: user)}

    it 'should update item from the list' do
      allow(Spree::RecurringList).to receive(:find).with(1).and_return(recurring_list)
      expect(recurring_list).to receive(:add_item).with("variant_id" => 123, "quantity" => 3).and_return(FactoryGirl.create(:recurring_list_item))

      api_put :update, id: 1, recurring_list_item: {variant_id: 123, quantity: 3}
      expect(response.status).to eq(200)
    end

    it 'should remove item from the list if destroy param is passed' do
      allow(Spree::RecurringList).to receive(:find).with(1).and_return(recurring_list)
      expect(recurring_list).to receive(:remove_item).with(:id => 123).and_return(true)

      api_put :update, id: 1, recurring_list_item: {id: 123, destroy: true}
      expect(response.status).to eq(200)
    end

    it 'should pause recurring order if list is empty' do
      allow(Spree::RecurringList).to receive(:find).with(1).and_return(recurring_list)
      allow(recurring_list).to receive(:items).and_return([])
      allow(recurring_list).to receive(:remove_item).with(:id => 123).and_return(true)
      expect(recurring_order).to receive(:update_attributes).with(active: false)

      api_put :update, id: 1, recurring_list_item: {id: 123, destroy: true}
      expect(response.status).to eq(200)
    end

    it 'should not pause recurring order if list is not empty' do
      allow(Spree::RecurringList).to receive(:find).with(1).and_return(recurring_list)
      allow(recurring_list).to receive(:items).and_return([Spree::RecurringListItem.new])
      allow(recurring_list).to receive(:remove_item).with(:id => 123).and_return(true)
      expect(recurring_order).not_to receive(:update_attributes)

      api_put :update, id: 1, recurring_list_item: {id: 123, destroy: true}
      expect(response.status).to eq(200)
    end


    it 'should fail if recurring list is not found' do
      api_put :update, id: 3, recurring_list_item: {variant_id: 123, quantity: 3}
      expect(response.status).to eq(404)
    end

    it 'should fail if update fails' do
      allow(Spree::RecurringList).to receive(:find).with(1).and_return(recurring_list)
      expect(recurring_list).to receive(:add_item).with("variant_id" => 123, "quantity" => 3).and_return(false)

      api_put :update, id: 1, recurring_list_item: {variant_id: 123, quantity: 3}
      expect(response.status).to eq(400)
    end

    it 'should not allow update if user doesnt own recurring list' do
      skip('The ability check does not work in dev')

      new_user = double(Spree::User, id: 3, :last_incomplete_spree_order => nil, :has_spree_role? => true, :spree_api_key => 'another_fake')
      allow(controller).to receive(:current_api_user).and_return(new_user)

      other_recurring_list = FactoryGirl.build(:recurring_list, user: user)
      allow(Spree::RecurringList).to receive(:find).with(1).and_return(other_recurring_list)
      expect(recurring_list).not_to receive(:add_item)

      api_put :update, id: 1, recurring_list_item: {variant_id: 123, quantity: 3}
      expect(response.status).to eq(401)
    end

    it 'should not allow update if user is not logged in' do
      allow(controller).to receive(:current_api_user).and_return(Spree.user_class.new)

      other_recurring_list = FactoryGirl.build(:recurring_list, user_id: 4)
      allow(Spree::RecurringList).to receive(:find).with(1).and_return(other_recurring_list)
      expect(recurring_list).not_to receive(:add_item)

      api_put :update, id: 1, recurring_list_item: {variant_id: 123, quantity: 3}
      expect(response.status).to eq(401)
    end

  end

end
