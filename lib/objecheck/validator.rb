# Validator checks a object with given schema and report errors
#
class Objecheck::Validator
  require 'objecheck/validator/type_rule'
  DEFAULT_RULES = {
    type: TypeRule
  }.freeze

  def initialize(schema, rules = DEFAULT_RULES)
    @rules = schema.map do |rule_name, param|
      rules[rule_name].new(param)
    end
  end

  def validate(target)
    collector = Collector.new(self)
    collector.add_prefix_in('root') do
      @rules.each do |rule|
        rule.validate(target, collector)
      end
    end
    collector.errors
  end
end

require 'objecheck/validator/collector'
