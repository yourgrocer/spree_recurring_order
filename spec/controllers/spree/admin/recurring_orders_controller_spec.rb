require 'spec_helper'

describe Spree::Admin::RecurringOrdersController do

  let(:user) { double Spree::User, :last_incomplete_spree_order => nil, :has_spree_role? => true, :spree_api_key => 'fake' }

  before :each do
    controller.stub :spree_current_user => user
    controller.stub :check_authorization
  end

  describe 'show' do

    it 'should assign recurring order' do
      recurring_order = double(Spree::RecurringOrder)
      Spree::RecurringOrder.should_receive(:find_by).with(number: 'R1234').and_return(recurring_order)

      spree_get :show, number: 'R1234'
      assigns(:recurring_order).should == recurring_order
    end

  end

end
