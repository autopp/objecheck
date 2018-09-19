describe Objecheck::Validator::RegexpRule do
  let(:rule) { described_class.new(instance_double(Objecheck::Validator), regexp) }
  let(:regexp) { /^[a-zA-Z_][a-zA-Z_0-9]*/ }

  describe '#validate' do
    subject { rule.validate(target, collector) }
    let(:collector) { instance_double(Objecheck::Validator::Collector) }

    context 'when target matches the given pattern' do
      let(:target) { 'foo_bar_1' }

      it 'dose not add error to collector' do
        expect(collector).not_to receive(:add_error)
        subject
      end
    end

    context 'when target dose not match to the given object' do
      let(:target) { '1_foo_bar' }

      it 'add error to collector' do
        expect(collector).to receive(:add_error).with("should match to #{regexp.inspect}")
        subject
      end
    end

    context 'when target is not acceptable to Regexp' do
      let(:target) { 1 }

      it 'add error to collector' do
        expect(collector).to receive(:add_error).with("should be acceptable to Regexp (type is #{target.class})")
        subject
      end
    end
  end
end
