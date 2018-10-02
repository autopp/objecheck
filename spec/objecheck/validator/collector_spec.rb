describe Objecheck::Validator::Collector do
  let(:collector) { described_class.new(validator) }
  let(:validator) { ::Objecheck::Validator.new({}, {}) }

  describe '#errors' do
    subject { collector.errors }

    it { is_expected.to be_a(Array) }

    it 'returns different object for each call' do
      expect(subject).not_to equal(collector.errors)
    end
  end

  describe '#validate' do
    subject { collector.validate(target, { type: Objecheck::Validator::TypeRule.new(validator, Integer) }) }

    context 'when target satisfies rules' do
      let(:target) { 42 }
      it { is_expected.to be_truthy }
    end

    context 'when target dose not satisfy rules' do
      let(:target) { '42' }
      it { is_expected.to be_falsey }
    end
  end

  describe '#add_prefix_in' do
    it { expect { |b| collector.add_prefix_in('[0]', &b) }.to yield_control }
  end

  describe '#add_error' do
    it 'records given message for later retrieval by #errors' do
      first = 'something is wrong'
      second = 'other is also wrong'
      collector.add_error(first)
      collector.add_error(second)

      expect(collector.errors).to eq([": : #{first}", ": : #{second}"])
    end

    context 'when called at block of #add_prefix_in' do
      it 'records given message with prefix for later retrieval by #errors' do
        first = 'something is wrong'
        second = 'other is also wrong'

        first_prefix = '[0]'
        second_prefix = '.foo'
        collector.add_prefix_in(first_prefix) do
          collector.add_error(first)

          collector.add_prefix_in(second_prefix) do
            collector.add_error(second)
          end
        end

        expect(collector.errors).to eq(["#{first_prefix}: : #{first}", "#{first_prefix}#{second_prefix}: : #{second}"])
      end
    end
  end

  describe '#transaction' do
    subject { collector.transaction }

    it 'has interface same as Collector' do
      expect(subject).to respond_to(:errors).with(0).arguments
      expect(subject).to respond_to(:add_prefix_in).with(1).argument
      expect(subject).to respond_to(:add_error).with(1).argument
      expect(subject).to respond_to(:validate).with(2).arguments
      expect(subject).to respond_to(:transaction).with(0).arguments
      expect(subject).to respond_to(:commit).with(1).argument
      expect(subject).to respond_to(:rollback).with(1).argument
    end

    context 'when another transaction is already created' do
      before { collector.transaction }

      it 'raises error' do
        expect { subject }.to raise_error(Objecheck::Error)
      end
    end
  end

  shared_context 'nested trasanction is created', nested_transactions: true do
    before do
      @t1 = collector.transaction
      @t2 = @t1.transaction
    end
  end

  describe '#commit' do
    it 'promotes errors in transaction' do
      t = collector.transaction
      msg = 'something is wrong'
      t.add_error(msg)
      collector.commit(t)
      expect(collector.errors).to eq([": : #{msg}"])
    end

    context 'when transaction is not created' do
      it 'raises error' do
        expect { collector.commit(nil) }.to raise_error(Objecheck::Error)
      end
    end

    context 'when nested transaction is created', nested_transactions: true do
      context 'and order of commit is correct' do
        it 'promotes errors in transaction' do
          msg = 'something is wrong'
          @t2.add_error(msg)
          @t1.commit(@t2)
          collector.commit(@t1)
          expect(collector.errors).to eq([": : #{msg}"])
        end
      end

      context 'and order of commit is wrong' do
        it 'raises error' do
          collector.add_error('something is wrong')
          expect { collector.commit(@t1) }.to raise_error(Objecheck::Error)
        end
      end
    end
  end

  describe '#rollback' do
    it 'discards errors in transaction' do
      t = collector.transaction
      msg = 'something is wrong'
      t.add_error(msg)
      collector.rollback(t)
      expect(collector.errors).to be_empty
    end

    context 'when nested transaction is created', nested_transactions: true do
      context 'and order of rollback is correct' do
        it 'discards errors in transaction' do
          @t2.add_error('something is wrong')
          @t1.rollback(@t2)
          collector.rollback(@t1)
          expect(collector.errors).to be_empty
        end
      end

      context 'and order of rollback is wrong' do
        it 'raises error' do
          collector.add_error('something is wrong')
          expect { collector.rollback(@t1) }.to raise_error(Objecheck::Error)
        end
      end
    end

    context 'when transaction is not created' do
      it 'raises error' do
        expect { collector.rollback(nil) }.to raise_error(Objecheck::Error)
      end
    end
  end
end
