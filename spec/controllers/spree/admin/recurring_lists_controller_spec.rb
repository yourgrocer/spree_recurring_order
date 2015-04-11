require 'spec_helper'

describe Spree::Admin::RecurringListsController do

  let(:user) { double Spree::User, :last_incomplete_spree_order => nil, :has_spree_role? => true, :spree_api_key => 'fake' }

  before :each do
    controller.stub :spree_current_user => user
    controller.stub :check_authorization
  end


  describe 'update' do

    let(:normal_user){double(Spree::User, email: 'test@email.com', last_incomplete_spree_order: nil).as_null_object}
    let(:recurring_order){double(Spree::RecurringOrder, number: '12345', id: '321')}
    let(:base_list){double(Spree::RecurringList, recurring_order: recurring_order)}

    it 'should update recurring list details' do
      allow(Spree::RecurringList).to receive(:find).with("1").and_return(base_list)
      expect(base_list).to receive(:update_attributes).with({"next_delivery_date" => 10.days.from_now.utc.to_s, "timeslot" => '4pm to 5:30pm'})
      spree_put :update, id: 1, recurring_list: {next_delivery_date: 10.days.from_now, timeslot: '4pm to 5:30pm'}
    end

    it 'should not update restricted fields' do
      allow(Spree::RecurringList).to receive(:find).with("1").and_return(base_list)
      expect(base_list).not_to receive(:update_attributes).with(hash_including(user: normal_user))
      spree_put :update, id: 1, recurring_list: {next_delivery_date: 10.days.from_now, timeslot: '4pm to 5:30pm', user: normal_user}
    end

    it 'should show validation errors if it fails'

    it 'should render recurring order' do
      allow(Spree::RecurringList).to receive(:find).with("1").and_return(base_list)
      allow(base_list).to receive(:update_attributes)
      spree_put :update, id: 1, recurring_list: {next_delivery_date: 10.days.from_now, timeslot: '4pm to 5:30pm'}
      expect(response).to redirect_to("/admin/recurring_orders/#{recurring_order.id}")
    end


  end

end
