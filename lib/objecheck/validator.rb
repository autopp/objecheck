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
