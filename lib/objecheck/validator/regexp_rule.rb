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

# RegexpRule validates string by regular expression
#
class Objecheck::Validator::RegexpRule
  def initialize(_validator, regexp)
    @regexp = regexp
  end

  def validate(target, collector)
    collector.add_error("should match to #{@regexp.inspect}") if !@regexp.match?(target)
  rescue TypeError
    collector.add_error("should be acceptable to Regexp (type is #{target.class})")
  end
end
