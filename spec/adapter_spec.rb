describe ApiCaller::Adapter do
  subject { described_class }

  it { is_expected.to respond_to(:get) }
  # it { is_expected.to respond_to(:post) } ....

  it { is_expected.to respond_to(:build_request) }
  it { is_expected.to respond_to(:configure) }
  it { is_expected.to respond_to(:use_base_url) }
  it { is_expected.to respond_to(:decorate) }

  describe '::build_request' do
    specify 'when route does not registered' do
      expect { described_class.build_request :non_registered_route }.to raise_error(ApiCaller::Error::MissingRoute)
    end

    context 'when route is registered without alias' do
      it { expect{ described_class.get 'url_template' }.to raise_error(ApiCaller::Error::MissingRouteName) }
    end

    context 'when route is registered as get verb' do
      let(:url_template) { 'http://example.com/{first}{?last,third}' }
      let(:request) { described_class.build_request(:test_route, params) }

      before do
        described_class.get url_template, as: :test_route
      end

      it_behaves_like 'a request builder'

      context 'when a request decorator registered' do
        let(:params) { { first: 'first' } }

        let(:fake_decorator) do
          Class.new(ApiCaller::Decorator) do
            def wrap(request)
              request.merge!({ last: 'last' })
            end
          end
        end

        around do |example|
          described_class.decorate with: fake_decorator
          example.run
          described_class.remove_decorator
        end

        it 'returns decorated result' do
          expect(request.url).to eq('http://example.com/first?last=last')
        end
      end
    end

    # context 'when route is registered as post verb' do
    # it 'returns set of parameters which has not been passed to url' do
  end

  describe '::configure' do
    let(:request) { described_class.build_request(:test_route, { }) }

    before do
      described_class.get 'url_template', as: :test_route
    end

    context 'when get changed' do
      before do
        described_class.configure { get 'new_url_template', as: :test_route }
      end

      it 'changes preset url value of route' do
        expect(request.url).to eq('new_url_template')
      end
    end

    context 'when base_url changed' do
      before do
        described_class.configure { use_base_url 'http://example.com' }
      end

      it 'changes preset url value of route' do
        expect(request.url).to eq('http://example.com/url_template')
      end
    end
  end

  describe '::base_url' do
    let(:request) { described_class.build_request(:test_route, { }) }

    before do
      described_class.use_base_url 'http://example.com'
      described_class.get 'url_template', as: :test_route
    end

    it 'sets right value of url' do
      expect(request.url).to eq('http://example.com/url_template')
    end
  end

  describe '::decorate' do
    context 'when called with :all symbol' do
      it 'calls decorator ctor with right arguments' do
        expect(ApiCaller::Decorator).to receive(:new).with(:all)
        described_class.decorate :all
      end
    end

    context 'when called for given route name' do
      let(:route_name) { :test_route_name }

      it 'calls decorator ctor with right arguments' do
        expect(ApiCaller::Decorator).to receive(:new).with(route_name)
        described_class.decorate route_name
      end
    end
  end

  describe '::remove_decorator' do
    before do
      @arr = []
      allow(ApiCaller::Adapter).to receive(:decorators).and_return(@arr)
      described_class.decorate :route_name
      described_class.remove_decorator
    end

    it 'removes specified decorator from registered ones' do
      expect(@arr.size).to eq 0
    end
  end
end