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

# TypeRule validates type of a target
#
class Objecheck::Validator::TypeRule
  def initialize(type)
    @type = type
  end

  def validate(target, collector)
    collector.add_error("the type should be a #{@type} (got #{target.class})") if !target.is_a?(@type)
  end
end
