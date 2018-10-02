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

# AnyRule validates that object meets one of the give rules
#
class Objecheck::Validator::AnyRule
  def initialize(validator, schemas)
    @child_rules = schemas.map do |schema|
      validator.compile_schema(schema)
    end
  end

  def validate(target, collector)
    t = collector.transaction
    t.add_error("should satisfy one of the #{@child_rules.size} schemas")
    t_for_nested_rules = t.transaction
    result = @child_rules.each.with_index(1).any? do |rules, i|
      t_for_nested_rules.add_prefix_in("(option #{i})") { t_for_nested_rules.validate(target, rules) }
    end

    if result
      t.rollback(t_for_nested_rules)
      collector.rollback(t)
    else
      t.commit(t_for_nested_rules)
      collector.commit(t)
    end
  end
end
