Spree Recurring Order
=====================


Before you invest time in trying to use this gem, here are some caveats:

- It does not process recurring payments
- It was built for quite a specific case, so please make sure it actually does what you want

This gem was built so the user can show the intention of subscribing to a recurring order. The way it works is:

1. User is presented with a recurring order option page after checkout
2. If the option is selected, the recurring order will appear in the 'Recurring Orders' tab in the admin section
3. Managing the recurring order after that is on your own. We are doing this by using the spree_repeat_order (https://github.com/frankmt/spree_repeat_order) gem

The gem also blocks the checkout path when a user has a recurring order in their cart, since the recurring orders are supposed to be processed offline.


Installation
------------

Add spree_recurring_order to your Gemfile:

```ruby
gem 'spree_recurring_order'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_recurring_order:install
```

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

```shell
bundle
bundle exec rake test_app
bundle exec rspec spec
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_recurring_order/factories'
```

Copyright (c) 2014 [name of extension creator], released under the New BSD License
