describe Objecheck::Validator::KeyValueRule do
  let(:rule) { described_class.new(validator, schema) }

  let(:validator) do
    validator = instance_double(Objecheck::Validator)
    int_schema = { type: Integer }
    int_rules = { type: Objecheck::Validator::TypeRule.new(validator, Integer) }
    allow(validator).to receive(:compile_schema).with(int_schema).and_return(int_rules)

    str_schema = { type: String }
    str_rules = { type: Objecheck::Validator::TypeRule.new(validator, String) }
    allow(validator).to receive(:compile_schema).with(str_schema).and_return(str_rules)

    validator
  end

  describe '#validate' do
    subject { rule.validate(target, collector) }
    let(:collector) { Objecheck::Validator::Collector.new(validator) }

    context 'when target responds to each_pair' do
      context 'and when schema requires :name as String and :age as Integer' do
        let(:schema) do
          {
            name: {
              value: { type: String }
            },
            age: {
              value: { type: Integer }
            }
          }
        end

        context 'and when target contains required key/value' do
          let(:target) { { name: 'John', age: 20 } }

          it 'dose not add error to collector' do
            expect(collector).not_to receive(:add_error)
            subject
          end
        end

        context 'and when target dose not satisfy required schema of key/value' do
          let(:target) { { name: 20, age: 'Jhon' } }

          it 'add errors to collector' do
            expect(collector).to receive(:add_error).twice
            subject
          end
        end

        context 'and when target dose not contains required key/value' do
          let(:target) { { name: 'Jhon' } }

          it 'add errors to collector' do
            expect(collector).to receive(:add_error).once
            subject
          end
        end
      end

      context 'and when schema requires :name as String and :age as Integer (optional)' do
        let(:schema) do
          {
            name: {
              value: { type: String }
            },
            age: {
              required: false,
              value: { type: Integer }
            }
          }
        end

        context 'and when target contains required key/value' do
          let(:target) { { name: 'John', age: 20 } }

          it 'dose not add error to collector' do
            expect(collector).not_to receive(:add_error)
            subject
          end
        end

        context 'and when target dose not contains optional key/value' do
          let(:target) { { name: 'Jhon' } }

          it 'dose not add error to collector' do
            expect(collector).not_to receive(:add_error)
            subject
          end
        end
      end
    end

    context 'when target dose not respond to each_pair' do
      let(:schema) { {} }
      let(:target) { nil }

      it 'add error to collector' do
        expect(collector).to receive(:add_error).with('should respond to `each_pair`')
        subject
      end
    end
  end
end
