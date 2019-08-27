require 'spec_helper'

describe DeepEq::Matcher do
  describe 'deep_eq' do
    let!(:matcher_object) { DeepEq::Matcher.new(expected) }
    let(:errors) { [] }

    before do
      allow(DeepEq::Matcher).to receive(:new).and_return(matcher_object)
      allow(matcher_object).to receive(:add_error).and_call_original
    end

    after do
      expect(matcher_object).to have_received(:add_error).exactly(errors.count).times

      errors.each do |error|
        expect(matcher_object).to have_received(:add_error).with(error)
      end
    end

    context 'equality check' do
      after do
        expect(current).to deep_eq expected
      end

      context 'when comparing integers' do
        let(:current) { 2 }
        let(:expected) { 2.0 }

        it 'passes' do; end
      end

      context 'when comparing strings' do
        let(:current) { 'abc' }
        let(:expected) { 'abc' }

        it 'passes' do; end
      end

      context 'when comparing symbols' do
        let(:current) { :def }
        let(:expected) { :"def" }

        it 'passes' do; end
      end

      context 'when comparing objects' do
        let(:current) { FakeRecord.new(value: 12) }
        let(:expected) { FakeRecord.new(value: 12.0) }

        it 'passes' do; end
      end

      context 'when comparing arrays' do
        let(:current) { [1, 4, 2] }
        let(:expected) { [1, 4, 2] }

        it 'passes' do; end

        context 'with arrays' do
          let(:current) { [1, 2, [3, 4, 5], 6, [7]] }
          let(:expected) { [1, 2, [3, 4, 5], 6, [7]] }

          it 'passes' do; end
        end

        context 'with hashes' do
          let(:current) { [1, 2, { foo: 'bar', baz: 1 }] }
          let(:expected) { [1, 2, { baz: 1, foo: 'bar' }] }

          it 'passes' do; end
        end
      end

      context 'when comparing hashes' do
        let(:current) { { one: 1, two: 2, three: 3 } }
        let(:expected) { { one: 1, three: 3, two: 2 } }

        it 'passes' do; end

        context 'with arrays' do
          let(:current) { { one: 1, two: [2, 3, 4]} }
          let(:expected) { { two: [2, 3, 4], one: 1 } }

          it 'passes' do; end
        end

        context 'with hashes' do
          let(:current) { { one: 1, two: { full: 2.0, half: 2.5 } } }
          let(:expected) { { two: { full: 2, half: 2.5 }, one: 1 } }

          it 'passes' do; end
        end
      end
    end

    context 'inequality check' do
      after do
        expect(current).to_not deep_eq expected
      end

      context 'when comparing integers' do
        let(:current) { 2 }
        let(:expected) { 3.0 }
        let(:errors) {
          ['value is invalid (expected 3.0, got 2)']
        }

        it 'passes with errors' do; end
      end

      context 'when comparing strings' do
        let(:current) { 'abc' }
        let(:expected) { 'abx' }
        let(:errors) {
          ['value is invalid (expected "abx", got "abc")']
        }

        it 'passes with errors' do; end
      end

      context 'when comparing symbols' do
        let(:current) { :def }
        let(:expected) { :"defo" }
        let(:errors) {
          ['value is invalid (expected :defo, got :def)']
        }

        it 'passes with errors' do; end
      end

      context 'when comparing objects' do
        let(:current) { FakeRecord.new(value: 12) }
        let(:expected) { FakeRecord.new(value: 13) }
        let(:errors) {
          ['value is invalid (expected #<FakeRecord @value=13>, got #<FakeRecord @value=12>)']
        }

        it 'passes with errors' do; end
      end

      context 'when comparing arrays' do
        context 'of integers' do
          let(:current) { [1, 4, 2] }
          let(:expected) { [1, 3, 2] }
          let(:errors) {
            ['value[1] is invalid (expected 3, got 4)']
          }

          it 'passes with errors' do; end
        end

        context 'with arrays' do
          let(:current) { [1, 2, [3, 5, 7], 6, [7]] }
          let(:expected) { [1, 2, [3, 4, 7], 6, [7]] }
          let(:errors) {
            ['value[2][1] is invalid (expected 4, got 5)']
          }

          it 'passes with errors' do; end
        end

        context 'with hashes' do
          let(:current) { [1, 2, { foo: 'bar', baz: 1 }] }
          let(:expected) { [1, 2, { foo: 'baz', baz: 1 }] }
          let(:errors) {
            ['value[2][:foo] is invalid (expected "baz", got "bar")']
          }

          it 'passes with errors' do; end
        end
      end

      context 'when comparing hashes' do
        context 'with integers' do
          let(:current) { { one: 1, two: 2, three: 3 } }
          let(:expected) { { one: 1, three: 30, two: 2 } }
          let(:errors) {
            ['value[:three] is invalid (expected 30, got 3)']
          }

          it 'passes with errors' do; end
        end


        context 'with arrays' do
          let(:current) { { one: 1, two: [2, 3, 4] } }
          let(:expected) { { two: [2, 3, 4], one: '1' } }
          let(:errors) {
            ['value[:one] is invalid (expected "1", got 1)']
          }

          it 'passes with errors' do; end
        end

        context 'with hashes' do
          let(:current) { { one: 1, two: { full: 2.0, half: 2.5 } } }
          let(:expected) { { two: { full: 2, half: 'e' }, one: 1 } }
          let(:errors) {
            ['value[:two][:half] is invalid (expected "e", got 2.5)']
          }

          it 'passes with errors' do; end
        end
      end

      context 'when comparing hash with integer' do
        let(:current) { {} }
        let(:expected) { [] }
        let(:errors) {
          ['value is expected to be Array, but Hash found']
        }

        it 'passes with errors' do; end
      end

      context 'when comparing hash with incorrect key' do
        let(:current) { { foo: { bar: { baz: 10 } } } }
        let(:expected) { { foo: { bar: { 'baz' => 10 } } } }
        let(:errors) {
          ['value[:foo][:bar] is expected to not contain keys: :baz']
        }

        it 'passes with errors' do; end
      end

      context 'when comparing arrays of different length' do
        context 'when expected is longer' do
          let(:current) { [nil, [1, 2]] }
          let(:expected) { [nil, [1, 2, 3, 4]] }
          let(:errors) {
            ['value[1] is expected to have length 4, but has 2']
          }

          it 'passes with errors' do; end
        end

        context 'when expected is shorter' do
          let(:current) { [[1, 2, 3, 4]] }
          let(:expected) { [[1, 2, 3]] }
          let(:errors) {
            ['value[0] is expected to have length 3, but has 4']
          }

          it 'passes with errors' do; end
        end
      end

      context 'when comparing objects with multiple errors' do
        let(:current) { [4, {}, [{ id: 10 }, { id: 15, name: 'Joe' }], { foo: { bar: :baz } }] }
        let(:expected) { [3, [], [{ id: 10 }, { id: 150 }], { foo: { bar: :not_baz } }] }
        let(:errors) {
          [
            'value[0] is invalid (expected 3, got 4)',
            'value[1] is expected to be Array, but Hash found',
            'value[2][1] is expected to not contain keys: :name',
            'value[3][:foo][:bar] is invalid (expected :not_baz, got :baz)'
          ]
        }

        it 'passes with errors' do; end
      end
    end
  end
end
