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

# Collector is used in Validator#validate to aggregate errors
#
class Objecheck::Validator::Collector
  def initialize(validator)
    @validator = validator
    @prefix_stack = []
    @errors = []
  end

  def add_prefix_in(prefix)
    @prefix_stack.push(prefix)
    yield
  ensure
    @prefix_stack.pop
  end

  def add_error(msg)
    @errors << "#{@prefix_stack.join('')}: #{msg}"
  end

  def errors
    @errors.dup
  end
end
