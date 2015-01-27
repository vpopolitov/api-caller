describe ApiCaller::Route do
  subject { described_class.new Hash.new }

  it { is_expected.to respond_to(:build_request) }
  it { is_expected.to respond_to(:template) }
  it { is_expected.to respond_to(:http_verb) }

  describe '#build_request' do
    let(:base_url)  { 'http://example.com/' }
    let(:context)   { ApiCaller::Context.new(base_url: base_url, raw_params: params) }
    let(:request)   { route.build_request context }
    let(:route)     { described_class.new template: '{first}{?last,third}',
                                          http_verb: http_verb }

    context 'when registered with get verb' do
      let(:http_verb) { :get }

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
  end
end