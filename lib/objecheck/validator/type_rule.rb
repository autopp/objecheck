# TypeRule validates type of a target
#
class Objecheck::Validator::TypeRule
  def initialize(type)
    @type = type
  end

  def validate(target)
    target.is_a?(@type) ? [] : ["the type should be a #{@type}"]
  end
end
