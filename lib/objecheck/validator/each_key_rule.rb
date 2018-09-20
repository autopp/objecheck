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

# EachKeyRule validates keys in the target by using each_key
#
class Objecheck::Validator::EachKeyRule
  def initialize(validator, key_schema)
    @key_rules = validator.compile_schema(key_schema)
  end

  def validate(target, collector)
    if !target.respond_to?(:each_key)
      collector.add_error('should respond to `each_key`')
      return
    end

    target.each_key do |key|
      collector.add_prefix_in("[#{key.inspect}]") do
        collector.validate(key, @key_rules)
      end
    end
  end
end
