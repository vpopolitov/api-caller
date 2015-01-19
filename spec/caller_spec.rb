describe ApiCaller do
  it { is_expected.to respond_to(:register) }
  it { is_expected.to respond_to(:call) }

  describe '::call' do
    context 'when adapter does not registered' do
      specify 'call raise an exception' do
        expect { described_class.call :test_adapter, :test_route }.to raise_error(ApiCaller::Error::MissingAdapter)
      end
    end

    context 'when adapter is registered' do
      let(:adapter_klass)            { TestAdapter }
      let(:snakecased_adapter_klass) { :test_adapter }
      let(:test_route)               { :test_route }

      let(:tested_url)    { 'http://api.stackexchange.com/2.2/badges/222?order=desc&sort=rank&site=stackoverflow' }
      let(:params)        { { badge_id: 222, order: 'desc', sort: 'rank', site: 'stackoverflow' } }
      let(:response_body) { 'shrimp' }

      before do
        @stubs = Faraday::Adapter::Test::Stubs.new do |stub|
          stub.get(tested_url) {[ 200, {}, 'shrimp' ]}
        end
        test = Faraday.new { |builder| builder.adapter :test, @stubs }
        described_class.http_adapter = test
      end

      context 'without an alias' do
        before do
          described_class.register adapter_klass
        end

        specify 'call must be made via snake-cased class name of adapter' do
          expect { described_class.call snakecased_adapter_klass, test_route, params }.to_not raise_error
        end
      end

      context 'with an alias' do
        let(:adapter_alias) { :adapter_alias }

        before do
          described_class.register adapter_klass, as: adapter_alias
        end

        specify 'call must be made via alias' do
          expect { described_class.call adapter_alias, test_route, params }.to_not raise_error
        end

        specify 'when route does not registered' do
          expect { described_class.call adapter_alias, :non_registered_route, params }.to raise_error(ApiCaller::Error::MissingRoute)
        end

        context 'when route is registered' do
          specify 'call must be made via query alias' do
            expect { described_class.call adapter_alias, test_route, params }.to_not raise_error
          end

          context '' do
            before do
              @res = described_class.call adapter_alias, test_route, params
            end

            specify 'call must go to the url defined by registered route in registered adapter' do
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