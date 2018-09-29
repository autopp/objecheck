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
    @current_rule_name = nil
    @prefix_stack = []
    @errors = []
    @transaction_stack = []
  end

  def add_prefix_in(prefix)
    @prefix_stack.push(prefix)
    yield
  ensure
    @prefix_stack.pop
  end

  def add_error(msg)
    msg = "#{@prefix_stack.join('')}: #{@current_rule_name}: #{msg}"
    if (_t, errors = @transaction_stack.last)
      errors << msg
    else
      @errors << msg
    end
  end

  def validate(target, rules)
    prev_rule_name = @current_rule_name
    rules.each do |name, rule|
      @current_rule_name = name
      rule.validate(target, self)
    end
  ensure
    @current_rule_name = prev_rule_name
  end

  def errors
    @errors.dup
  end

  def transaction
    t = Transaction.new(self)
    @transaction_stack << [t, []]
    t
  end

  def commit(t)
    errors_in_t = pop_errors_is_transaction(t)
    parrent_errors = @transaction_stack.empty? ? @errors : @transaction_stack.last[1]
    parrent_errors.concat(errors_in_t)
  end

  def rollback(t)
    pop_errors_is_transaction(t)
  end

  private

  def pop_errors_is_transaction(t)
    raise Objecheck::Error, 'no transaction created' if @transaction_stack.empty?

    current_t, errors_in_t = @transaction_stack.last
    raise Objecheck::Error, "invalid transaction #{t} (current: #{current_t})" if !t.equal?(current_t)

    @transaction_stack.pop
    errors_in_t
  end

  # Transaction is created by Collector#transaction and represents unit of transaction
  #
  class Transaction
    def initialize(collector)
      @collector = collector
      @errors = []
    end

    def add_error(msg)
      @errors << msg
      self
    end
  end
end
