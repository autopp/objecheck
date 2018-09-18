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
