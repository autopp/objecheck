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

# EachRule validates elements in the target by using each
#
class Objecheck::Validator::EachRule
  def initialize(validator, element_schema)
    @element_rules = validator.compile_schema(element_schema)
  end

  def validate(target, collector)
    if !target.respond_to?(:each)
      collector.add_error('should respond to `each`')
      return
    end

    target.each.with_index do |elem, i|
      collector.add_prefix_in("[#{i}]") do
        collector.validate(elem, @element_rules)
      end
    end
  end
end
