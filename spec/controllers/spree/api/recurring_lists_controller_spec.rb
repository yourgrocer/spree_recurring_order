require 'spec_helper'

describe Spree::Api::RecurringListsController do

  let(:user) { mock_model Spree::User, :last_incomplete_spree_order => nil, :has_spree_role? => true, :spree_api_key => 'fake' }

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

    it 'should create recurring list for user if it doesnt exist'

    it 'should display message if update is successful'

    it 'should display error message if update fails'

    it 'should not allow update if user doesnt own recurring list'

    it 'should not allow update if user is not logged in'

  end

end
