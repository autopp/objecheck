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
