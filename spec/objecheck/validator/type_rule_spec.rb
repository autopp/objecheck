describe Objecheck::Validator::TypeRule do
  let(:rule) { described_class.new(instance_double(Objecheck::Validator), type) }
  let(:type) { Hash }

  describe '#validate' do
    subject { rule.validate(target, collector) }
    let(:collector) { instance_double(Objecheck::Validator::Collector) }

    context 'when target is the given type' do
      let(:target) { {} }

      it 'dose not add error to collector' do
        expect(collector).not_to receive(:add_error)
        subject
      end
    end

    context 'when target is not the given type' do
      let(:target) { [] }

      it 'add error to collector' do
        expect(collector).to receive(:add_error).with('the type should be a Hash (got Array)')
        subject
      end
    end
  end
end
