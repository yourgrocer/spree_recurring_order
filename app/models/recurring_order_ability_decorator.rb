class RecurringOrderAbilityDecorator
  include CanCan::Ability

  def initialize(user)
    raise CanCan::AccessDenied.new("Unauthorized") unless user

    can :update, Spree::RecurringList do |recurring_list|
      recurring_list.user_id == user.id
    end
  end

end

Spree::Ability.register_ability(RecurringOrderAbilityDecorator)
