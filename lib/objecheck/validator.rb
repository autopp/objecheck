# Validator checks a object with given schema and report errors
#
class Objecheck::Validator
  def initialize(type:)
    @type = type
  end

  def validate(target)
    errors = []
    errors << "shoud be a #{@type}" if !target.is_a?(@type)
    errors
  end
end

require 'objecheck/validator/hash_validator'
