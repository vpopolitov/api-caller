describe ApiCaller do
  it { is_expected.to respond_to(:register) }
  it { is_expected.to respond_to(:call) }
  it { is_expected.to respond_to(:use_http_adapter) }

  describe '::call' do
    context 'when service does not registered' do
      specify 'call raise an exception' do
        expect { described_class.call :test_service, :test_route }.to raise_error(ApiCaller::Error::MissingService)
      end
    end

    context 'when service is registered' do
      let(:service_klass)            { TestService }
      let(:snakecased_service_klass) { :test_service }
      let(:test_route)               { :test_route }

      let(:tested_url)    { 'http://api.stackexchange.com/2.2/badges/222?order=desc&sort=rank&site=stackoverflow' }
      let(:params)        { { badge_id: 222, order: 'desc', sort: 'rank', site: 'stackoverflow' } }
      let(:response_body) { 'shrimp' }

      before do
        @stubs = Faraday::Adapter::Test::Stubs.new do |stub|
          stub.get(tested_url) {[ 200, {}, 'shrimp' ]}
        end
        test = Faraday.new { |builder| builder.adapter :test, @stubs }
        # in testing purposes we need to make assignment to service instead of caller
        # because in case of caller assignment we use the first instance of @stubs for all tests
        # and therefore call to @stubs.verify_stubbed_calls will be failed - this stubs created later
        # but call go through the first instance of stub
        service_klass.use_http_adapter test
      end

      context 'without an alias' do
        before do
          described_class.register service_klass
        end

        specify 'call must be made via snake-cased class name of service' do
          expect { described_class.call snakecased_service_klass, test_route, params }.to_not raise_error
        end
      end

      context 'with an alias' do
        let(:service_alias) { :service_alias }

        before do
          described_class.register service_klass, as: service_alias
        end

        specify 'call must be made via alias' do
          expect { described_class.call service_alias, test_route, params }.to_not raise_error
        end

        specify 'when route does not registered' do
          expect { described_class.call service_alias, :non_registered_route, params }.to raise_error(ApiCaller::Error::MissingRoute)
        end

        context 'when route is registered' do
          specify 'call must be made via query alias' do
            expect { described_class.call service_alias, test_route, params }.to_not raise_error
          end

          context 'when call is made' do
            before do
              @res = described_class.call service_alias, test_route, params
            end

            specify 'call must go to the url defined by registered route in registered service' do
              expect { @stubs.verify_stubbed_calls }.to_not raise_error
            end

            specify 'call should return right status code' do
              expect(@res.status).to eq 200
            end

            specify 'call should return right response body' do
              expect(@res.body).to eq 'shrimp'
            end
          end
        end
      end
    end
  end
end