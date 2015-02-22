require 'spec_helper'

describe Spree::Admin::RecurringOrders::RecurringListOrdersController do

  let(:user) { double Spree::User, :last_incomplete_spree_order => nil, :has_spree_role? => true, :spree_api_key => 'fake' }

  before :each do
    controller.stub :spree_current_user => user
    controller.stub :check_authorization
  end

  describe 'create' do

    it 'should create new order based on recurring list' do
      user = FactoryGirl.build(:user, email: 'test@email.com')
      recurring_list = FactoryGirl.build(:recurring_list, user: user)
      recurring_order = Spree::RecurringOrder.create(recurring_lists: [recurring_list])

      spree_post :create, recurring_order_id: recurring_order.id 

      created_order = Spree::Order.last
      expect(created_order.email).to eq(user.email)
      expect(created_order.created_by).to eq(user)
    end

    it 'should add items from base list'
    it 'should fail if recurring order doesnt have a base list'
    it 'should display error if delivery time is invalid'
    it 'should fail if user has already an order in progress'
    it 'should merge with cart order if user has one'

  end

end
