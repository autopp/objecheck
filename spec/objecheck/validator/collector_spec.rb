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

    context 'when transaction is created by #transaction' do
      before do
        @t = collector.transaction
      end

      it 'records given message but not shown by #errors' do
        collector.add_error('something is wrong')
        expect(collector.errors).to be_empty
      end
    end
  end

  describe '#commit' do
    it 'promotes errors in transaction' do
      t = collector.transaction
      msg = 'something is wrong'
      collector.add_error(msg)
      collector.commit(t)
      expect(collector.errors).to eq([": : #{msg}"])
    end

    context 'when nested transaction is created' do
      context 'and order of commit is correct' do
        it 'promotes errors in transaction' do
          t1 = collector.transaction
          t2 = collector.transaction
          msg = 'something is wrong'
          collector.add_error(msg)
          collector.commit(t2)
          collector.commit(t1)
          expect(collector.errors).to eq([": : #{msg}"])
        end
      end

      context 'and order of commit is wrong' do
        it 'promotes errors in transaction' do
          t1 = collector.transaction
          _t2 = collector.transaction
          msg = 'something is wrong'
          collector.add_error(msg)
          expect { collector.commit(t1) }.to raise_error(Objecheck::Error)
        end
      end
    end
  end

  describe '#rollback' do
    it 'discards errors in transaction' do
      t = collector.transaction
      msg = 'something is wrong'
      collector.add_error(msg)
      collector.rollback(t)
      expect(collector.errors).to be_empty
    end

    context 'when nested transaction is created' do
      context 'and order of rollback is correct' do
        it 'discards errors in transaction' do
          t1 = collector.transaction
          t2 = collector.transaction
          collector.add_error('something is wrong')
          collector.rollback(t2)
          collector.rollback(t1)
          expect(collector.errors).to be_empty
        end
      end

      context 'and order of rollback is wrong' do
        it 'raises error' do
          t1 = collector.transaction
          _t2 = collector.transaction
          collector.add_error('something is wrong')
          expect { collector.rollback(t1) }.to raise_error(Objecheck::Error)
        end
      end
    end
  end
end
