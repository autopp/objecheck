# Objecheck

[![Gem Version](https://badge.fury.io/rb/objecheck.svg)](https://badge.fury.io/rb/objecheck)
[![CircleCI](https://circleci.com/gh/autopp/objecheck/tree/master.svg?style=shield)](https://circleci.com/gh/autopp/objecheck/tree/master)

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

# Validate type of keys and values
validator = Objecheck::Validator.new({
  each_key: { type: Symbol }
  each_value: { type: Integer }
})

p validator.validate({ a: 1, b: 2 }) # => []

# Validate array that contains specific key/value
validator = Objecheck::Validator.new({
  type: Array,
  each: {
    key_value: {
      name: {
        value: { type: String }
      },
      age: {
        required: false,
        value: { type: Integer }
      }
    }
  }
})

p validator.validate([{ name: 'Jhon', age: 20 }, { name: 'Tom' }]) # => []
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

When you want to check that value is a boolean (`true` or `false`), use `:bool`.
```ruby
{
  type: :bool
}
```

### `each`

`each` checks elements of the object by using `each`.

Example schema:
```ruby
{
  each: {
    type: Integer
  }
}
```

### `each_key`

`each_key` checks keys of the object by using `each_key`.

Example schema:
```ruby
{
  each_key: {
    type: Symbol
  }
}
```

### `each_value`

`each_value` checks values of the object by using `each_pair`.

Example schema:
```ruby
{
  each_value: {
    type: Integer
  }
}
```

### `key_value`

`key_value` checks key/values of the object by using `each_pair`.

Example schema:
```ruby
{
  key_value: {
    name: {
      value: { type: String }
    },
    age: {
      required: false # Default is true
      value: { type: Integer }
    }
  }
}
```

### `eq`

`eq` checks equality of values.

Example schema:
```ruby
{
  eq: 'foo'
}
```

### `any`

`any` makes disjunction of rules.

Example schema:
```ruby
{
  any: [
    { type: Integer },
    { type: String }
  ]
}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/autopp/objecheck.

## License

[Apache License 2.0](LICENSE.txt)
