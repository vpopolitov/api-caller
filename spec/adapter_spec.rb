describe ApiCaller::Adapter do
  subject { described_class }

  it { is_expected.to respond_to(:get) }
  # it { is_expected.to respond_to(:post) } ....

  it { is_expected.to respond_to(:fetch_route) }

  describe '::fetch_route' do
    specify 'when route does not registered' do
      expect { described_class.fetch_route :non_registered_route }.to raise_error(ApiCaller::Error::MissingRoute)
    end

    context 'when route is registered without alias' do
      it { expect{ described_class.get 'url_pattern' }.to raise_error(ApiCaller::Error::MissingRouteName) }
    end

    context 'when route is registered as get verb' do
      before do
        described_class.get 'url_pattern', as: :test_route
      end

      let(:params) { { first: :first, last: :last } }
      let(:route)  { described_class.fetch_route(:test_route, params) }

      it 'returns proper HTTP verb' do
        # TODO:: extract verbs to constant
        expect(route.http_verb).to eq(:get)
      end

      it 'returns url with parameters' do
        expect(route.url).to eq('url_pattern')
      end

      it 'returns empty set of parameters' do
        expect(route.body).to eq({})
      end
    end

    # context 'when route is registered as post verb' do
    # it 'returns set of parameters which has not been passed to url' do
  end
end