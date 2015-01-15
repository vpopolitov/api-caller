describe ApiCaller do
  it { is_expected.to respond_to(:register) }
  it { is_expected.to respond_to(:call).with(3).arguments }

  describe '::call' do

    context 'when adapter does not registered' do
      specify 'call raise an exception' do
        expect { described_class.call :test_adapter }.to raise_error(ApiCaller::Error::MissingAdapter)
      end
    end

    context 'when adapter is registered' do

      context 'with an alias' do
        specify 'call must be made via alias' do
          expect { described_class.call :test_adapter }.to_not raise_error(ApiCaller::Error::MissingAdapter)
        end
      end

      context 'without an alias' do
        specify 'call must be made via snake-cased class name of adapter' do
          expect { described_class.call :test_adapter }.to_not raise_error(ApiCaller::Error::MissingAdapter)
        end
      end

      specify 'when query does not registered' do
        expect { described_class.call :test_adapter, :test_query }.to raise_error(ApiCaller::Error::MissingQuery)
      end

      context 'when query is registered' do
        specify 'call must be made via query alias' do
          expect { described_class.call :test_adapter, :test_query }.to_not raise_error(ApiCaller::Error::MissingQuery)
        end
      end

    end
  end
end