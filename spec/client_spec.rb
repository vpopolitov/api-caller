describe ApiCaller::Client do
  before do
    @stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get(tested_url) {[ 200, {}, 'shrimp' ]}
    end
    @test = Faraday.new { |builder| builder.adapter :test, @stubs }
  end

  let(:tested_url) { 'http://example.com' }
  let(:client)     { described_class.new(@test) }
  let(:request)    { ApiCaller::Request.new http_verb: :get, url: tested_url }
  
  subject { client }

  it { is_expected.to respond_to(:build_response) }

  describe '#build_response' do
    before { client.build_response request }

    it 'makes a request to specified url' do
      expect { @stubs.verify_stubbed_calls }.to_not raise_error
    end
  end
end