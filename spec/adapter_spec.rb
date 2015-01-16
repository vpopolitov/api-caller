describe ApiCaller::Adapter do
  subject { described_class }

  it { is_expected.to respond_to(:get) }
  # it { is_expected.to respond_to(:post) } ....

  it { is_expected.to respond_to(:fetch_route) }
  it { is_expected.to respond_to(:configure) }

  describe '::fetch_route' do
    specify 'when route does not registered' do
      expect { described_class.fetch_route :non_registered_route }.to raise_error(ApiCaller::Error::MissingRoute)
    end

    context 'when route is registered without alias' do
      it { expect{ described_class.get 'url_pattern' }.to raise_error(ApiCaller::Error::MissingRouteName) }
    end

    context 'when route is registered as get verb' do
      let(:params) do
        { first: :first, second: :second, last: :last }
      end
      let(:url_pattern) { 'http://example.com/:first?last=:last&third=:third' }
      let(:route) { described_class.fetch_route(:test_route, params) }

      before do
        described_class.get url_pattern, as: :test_route
      end

      it 'returns proper HTTP verb' do
        # TODO:: extract verbs to constant
        expect(route.http_verb).to eq(:get)
      end

      describe 'properly substitute url pattern parameters' do
        context 'when value for resource parameters does not provided' do
          let(:params) do
            { second: :second, last: :last }
          end

          specify 'fetch raises an error' do
            expect { described_class.fetch_route(:test_route, params) }.
                to raise_error(ApiCaller::Error::MissingResourceParameterValue)
          end
        end

        context 'when appropriate value does not provided' do
          let(:params) do
            { first: :first, last: :last }
          end

          specify 'skip query parameter' do
            expect(route.url).to eq('http://example.com/first?last=last')
          end

          specify 'body returns empty collection' do
            expect(route.body).to eq({})
          end
        end

        context 'when exceeded parameters are presented' do
          let(:params) do
            { first: :first, second: :second, last: :last }
          end

          specify 'returns well-formed url' do
            expect(route.url).to eq('http://example.com/first?last=last')
          end

          specify 'body returns empty collection' do
            expect(route.body).to eq({})
          end
        end

        context 'when all parameters are presented' do
          let(:params) do
            { first: :first, last: :last }
          end

          specify 'returns well-formed url' do
            expect(route.url).to eq('http://example.com/first?last=last')
          end

          specify 'body returns empty collection' do
            expect(route.body).to eq({})
          end
        end
      end
    end

    # context 'when route is registered as post verb' do
    # it 'returns set of parameters which has not been passed to url' do
  end

  describe '::configure' do
    let(:updated_params) { { first: :first, last: :last } }
    let(:route) { described_class.fetch_route(:test_route, { }) }

    before do
      described_class.get 'url_pattern', as: :test_route
      described_class.configure { get 'new_url_pattern', as: :test_route }
    end

    it 'changes preset values of route' do
      expect(route.url).to eq('new_url_pattern')
    end
  end
end