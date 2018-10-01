describe Objecheck::Validator::AnyRule do
  let(:rule) { described_class.new(validator, schemas) }

  let(:validator) do
    validator = instance_double(Objecheck::Validator)

    first_rules = { type: Objecheck::Validator::TypeRule.new(validator, String) }
    allow(validator).to receive(:compile_schema).with(first_schema).and_return(first_rules)

    second_rules = { type: Objecheck::Validator::TypeRule.new(validator, Integer) }
    allow(validator).to receive(:compile_schema).with(second_schema).and_return(second_rules)

    validator
  end
  let(:schemas) { [first_schema, second_schema] }
  let(:first_schema) { { type: String } }
  let(:second_schema) { { type: Integer } }

  describe '#validate' do
    subject { rule.validate(target, collector) }
    let(:collector) { Objecheck::Validator::Collector.new(validator) }

    context 'when target satisfies the first schema' do
      let(:target) { 'foo' }

      it 'dose not add error to collector' do
        subject
        expect(collector.errors).to be_empty
      end
    end

    context 'when target satisfies the second schema' do
      let(:target) { 42 }

      it 'dose not add error to collector' do
        subject
        expect(collector.errors).to be_empty
      end
    end

    context 'when target dose not satisfy all schema' do
      let(:target) { {} }

      it 'add errors to collector' do
        subject
        expect(collector.errors).not_to be_empty
      end
    end
  end
end
