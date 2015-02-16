# Terrific

Exception handling for your Rails API.

## Installation

Add this line to your application's Gemfile:

    gem 'terrific'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install terrific

## Usage

Simply use `map_error` in your controller:

```ruby
class ApplicationController < ActionController::Base
  map_error MyAppError::Base, to: :unprocessable_entity
  map_error "MyAppError::Other", to: :not_found
end
```

## Contributing

1. Fork it ( http://github.com/jasonkriss/terrific/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
