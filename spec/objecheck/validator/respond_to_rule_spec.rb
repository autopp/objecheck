describe Objecheck::Validator::RespondToRule do
  let(:rule) { described_class.new(instance_double(Objecheck::Validator), %i[zero? even? times]) }
  let(:methods) { 'foo' }

  describe '#validate' do
    subject { rule.validate(target, collector) }
    let(:collector) { instance_double(Objecheck::Validator::Collector) }

    context 'when target is respond to all given methods' do
      let(:target) { 42 }

      it 'dose not add error to collector' do
        expect(collector).not_to receive(:add_error)
        subject
      end
    end

    context 'when target is not respond to all given methods' do
      let(:target) { 3.14 }

      it 'add error to collector' do
        expect(collector).to receive(:add_error).with('should be respond to even?, times')
        subject
      end
    end
  end
end
