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
  attr_reader :current_rule_name, :prefix_stack, :current_t

  def initialize(validator, parent = nil)
    @validator = validator
    @current_validation_result = true
    @current_rule_name = parent ? parent.current_rule_name : nil
    @prefix_stack = parent ? [parent.prefix_stack.join('')] : []
    @errors = []
    @current_t = nil
  end

  def add_prefix_in(prefix)
    @prefix_stack.push(prefix)
    yield
  ensure
    @prefix_stack.pop
  end

  def add_error(msg)
    @current_validation_result = false
    @errors << "#{@prefix_stack.join('')}: #{@current_rule_name}: #{msg}"
  end

  def validate(target, rules)
    prev_rule_name = @current_rule_name
    prev_validation_result = @current_validation_result
    rules.each do |name, rule|
      @current_rule_name = name
      rule.validate(target, self)
    end
    @current_validation_result
  ensure
    @current_rule_name = prev_rule_name
    @current_validation_result = prev_validation_result
  end

  def errors
    @errors.dup
  end

  def transaction
    raise Objecheck::Error, 'another transaction is already created' if @current_t

    @current_t = self.class.new(@validator, self)
  end

  def commit(t)
    check_transaction(t)
    @current_t = nil
    @errors.concat(t.errors)
  end

  def rollback(t)
    check_transaction(t)
    @current_t = nil
  end

  private

  def check_transaction(t)
    raise Objecheck::Error, 'transaction is not created' if !@current_t

    raise Objecheck::Error, "invalid transaction #{t} (current: #{@current_t})" if !t.equal?(@current_t)

    raise Objecheck::Error, "transaction hash uncommited nested transaction (#{t.current_t})" if t.current_t
  end
end
