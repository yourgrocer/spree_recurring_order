require 'spec_helper'

describe Spree::RecurringListItemsController do

  let(:user) { double Spree::User, :last_incomplete_spree_order => nil, :has_spree_role? => true, :spree_api_key => 'fake' }

  before :each do
    controller.stub :spree_current_user => user
    controller.stub :check_authorization

    allow(Spree::User).to receive(:find).and_return(user)
  end

  it 'should delete item' do
    item = FactoryGirl.create(:recurring_list_item)
    spree_delete :destroy, id: item.id
    expect(Spree::RecurringListItem.where(id: item.id)).to be_empty
  end

end

