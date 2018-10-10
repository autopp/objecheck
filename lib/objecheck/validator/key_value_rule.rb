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

# KeyValueRule validates key/value in the target by using each_pair
#
class Objecheck::Validator::KeyValueRule
  def initialize(validator, key_value_schema)
    @key_value_rules = key_value_schema.each_with_object({}) do |(key, schema), rules|
      rules[key] = {
        required: schema.fetch(:required, true),
        rule: validator.compile_schema(schema[:value])
      }
    end
  end

  def validate(target, collector)
    if !target.respond_to?(:each_pair)
      collector.add_error('should respond to `each_pair`')
      return
    end

    @key_value_rules.each_pair do |key, rule|
      if target.key?(key)
        collector.add_prefix_in("[#{key.inspect}]") do
          collector.validate(target[key], rule[:rule])
        end
      elsif rule[:required]
        collector.add_error("should contain key #{key.inspect}")
      end
    end
  end

  def self.schema
    [
      {
        type: Hash,
        each_value: {
          type: Hash,
          key_value: {
            required: { required: false, value: { type: :bool } },
            value: { value: { type: Hash } }
          }
        }
      }
    ]
  end
end
