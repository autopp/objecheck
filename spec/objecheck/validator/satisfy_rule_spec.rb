describe Objecheck::Validator::SatisfyRule do
  let(:rule) { described_class.new(instance_double(Objecheck::Validator), pred) }
  let(:pred) { ->(x) { x.even? } }

  describe '#validate' do
    subject { rule.validate(target, collector) }
    let(:collector) { instance_double(Objecheck::Validator::Collector) }

    context 'when target satisfies given proc' do
      let(:target) { 0 }

      it 'dose not add error to collector' do
        expect(collector).not_to receive(:add_error)
        subject
      end
    end

    context 'when target dose not satisfy given proc' do
      let(:target) { 1 }

      it 'add error to collector' do
        expect(collector).to receive(:add_error).with("should satisfy #{pred.inspect}")
        subject
      end
    end
  end
end
