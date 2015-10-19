require 'spec_helper'

describe Spree::User do
  let!(:user){FactoryGirl.create(:user, email: 'test@email.com')}
  let!(:recurring_order){FactoryGirl.create(:recurring_order)}
  let!(:recurring_list){FactoryGirl.create(:recurring_list, recurring_order: recurring_order, user: user)}

  describe 'destroy' do
    it 'should delete the regular order when the user is deleted' do
      expect { user.destroy }.to change { Spree::RecurringList.count }.by(-1)
    end
  end
end
