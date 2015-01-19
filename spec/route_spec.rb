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

      it_behaves_like 'a request builder'
    end
  end
end