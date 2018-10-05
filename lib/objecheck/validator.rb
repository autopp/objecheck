#
# Objecheck
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#

# Validator checks a object with given schema and report errors
#
class Objecheck::Validator
  require 'objecheck/validator/type_rule'
  require 'objecheck/validator/each_rule'
  require 'objecheck/validator/each_key_rule'
  require 'objecheck/validator/each_value_rule'
  require 'objecheck/validator/key_value_rule'
  require 'objecheck/validator/eq_rule'
  require 'objecheck/validator/any_rule'
  DEFAULT_RULES = {
    type: TypeRule,
    each: EachRule,
    each_key: EachKeyRule,
    each_value: EachValueRule,
    key_value: KeyValueRule,
    any: AnyRule
  }.freeze

  def initialize(schema, rule_map = DEFAULT_RULES, schema_validation = true)
    @rule_map = rule_map
    @rules = compile_schema(schema, schema_validation)
  end

  def validate(target)
    collector = Collector.new(self)
    collector.add_prefix_in('root') do
      collector.validate(target, @rules)
    end
    collector.errors
  end

  def compile_schema(schema, schema_validation = true)
    schema.each_with_object({}) do |(rule_name, param), rules|
      rule_class = @rule_map[rule_name]
      if schema_validation && rule_class.respond_to?(:schema)
        param_schema, param_rule_map = rule_class.schema
        param_validator = Objecheck::Validator.new(param_schema, param_rule_map || DEFAULT_RULES, false)
        raise Objecheck::Error, 'parameter error' if !param_validator.validate(param).empty?
      end
      rules[rule_name] = rule_class.new(self, param)
    end
  end
end

require 'objecheck/validator/collector'
