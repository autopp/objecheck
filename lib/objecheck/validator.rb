# Validator checks a object with given schema and report errors
#
class Objecheck::Validator
  def initialize(**schema)
    @rules = schema.map do |rule_name, param|
      Objecheck::Validator.rules[rule_name].new(param)
    end
  end

  def validate(target)
    @rules.flat_map do |rule|
      rule.validate(target)
    end
  end

  @rules = {}
  class <<self
    attr_reader :rules

    def add_rule(name, rule_class)
      @rules[name] = rule_class
    end
  end
end

require 'objecheck/validator/type_rule'
