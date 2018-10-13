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

# RespondToRule validates methods of object
#
class Objecheck::Validator::RespondToRule
  def initialize(_validator, methods)
    @methods = methods
  end

  def validate(target, collector)
    not_responds = @methods.reject { |m| target.respond_to?(m) }
    collector.add_error("should be respond to #{not_responds.join(', ')}") if !not_responds.empty?
  end
end
