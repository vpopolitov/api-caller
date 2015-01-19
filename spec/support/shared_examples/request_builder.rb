RSpec.shared_examples 'a request builder' do
  describe '#http_verb' do
    let(:params) { {} }

    it 'returns right value' do
      # TODO:: extract verbs to constant
      expect(request.http_verb).to eq(:get)
    end
  end

  describe 'properly forms url' do
    context 'when appropriate value does not provided' do
      let(:params) do
        { first: :first, last: :last }
      end

      it 'skip query parameter' do
        expect(request.url).to eq('http://example.com/first?last=last')
      end

      it 'returns empty collection as a body' do
        expect(request.body).to eq({})
      end
    end

    context 'when exceeded parameters are presented' do
      let(:params) do
        { first: :first, second: :second, last: :last }
      end

      it 'returns well-formed url' do
        expect(request.url).to eq('http://example.com/first?last=last')
      end

      it 'returns empty collection as a body' do
        expect(request.body).to eq({})
      end
    end

    context 'when all parameters are presented' do
      let(:params) do
        { first: :first, last: :last }
      end

      it 'returns well-formed url' do
        expect(request.url).to eq('http://example.com/first?last=last')
      end

      it 'returns empty collection as a body' do
        expect(request.body).to eq({})
      end
    end
  end
end