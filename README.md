# Objecheck

Objecheck provides a simple and extensible object validator

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'objecheck'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install objecheck

## Usage

```ruby
require 'objecheck'

# Create a validator with rules
validator = Objecheck::Validator.new({
  type: Hash
})

# Validator#validate checks the given object and returns error messages as a array
p validator.validate({ a: 1, b: 2 }) # => []
p validator.validate([1, 2]) # => ["root: the type should be a Hash (got Array)"]
```

## Builtin rules

### `type`

`type` checks that the object is a given class (by `is_a?`).

Example schema:
```ruby
{
  type: Hash
}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/autopp/objecheck.

## License

[Apache License 2.0](LICENSE.txt)
