describe Objecheck::Validator::EqRule do
  let(:rule) { described_class.new(instance_double(Objecheck::Validator), value) }
  let(:value) { 'foo' }

  describe '#validate' do
    subject { rule.validate(target, collector) }
    let(:collector) { instance_double(Objecheck::Validator::Collector) }

    context 'when target is equal to given object' do
      let(:target) { 'foo' }

      it 'dose not add error to collector' do
        expect(collector).not_to receive(:add_error)
        subject
      end
    end

    context 'when target is not equal to given object' do
      let(:target) { 'bar' }

      it 'add error to collector' do
        expect(collector).to receive(:add_error).with("should be equal to #{value.inspect}")
        subject
      end
    end
  end
end
