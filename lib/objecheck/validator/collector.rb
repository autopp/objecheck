# Collector is used in Validator#validate to aggregate errors
#
class Objecheck::Validator::Collector
  def initialize(validator)
    @validator = validator
  end

  def errors
    []
  end
end
