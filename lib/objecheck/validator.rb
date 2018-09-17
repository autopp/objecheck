class Objecheck::Validator
  def initialize(type:)
    @type = type
  end

  def validate(target)
    errors = []
    errors << "shoud be a #{@type}" if !target.is_a?(@type)
    errors
  end
end
