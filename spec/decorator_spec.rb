describe ApiCaller::Decorator do
  let(:request) { ApiCaller::Request.new({}) }

  it { is_expected.to respond_to(:execute) }

  describe '#initialize' do
    context 'when created with :all symbol' do
      before do
        @decorator = ApiCaller::Decorator.new(:all)
      end

      it 'can be called for any action' do
        expect(@decorator).to receive(:wrap).twice
        @decorator.execute(request, :one)
        @decorator.execute(request, :two)
      end
    end

    context 'when created for given route name' do
      before do
        @decorator = ApiCaller::Decorator.new(:two)
      end

      it 'should be called only for specified action' do
        expect(@decorator).to receive(:wrap).once
        @decorator.execute(request, :one)
        @decorator.execute(request, :two)
      end
    end
  end

  describe '#execute' do
    context 'when result returned' do
      subject { described_class.new.execute(request, :test_route_name) }

      it { is_expected.to respond_to(:http_verb) }
      it { is_expected.to respond_to(:url) }
      it { is_expected.to respond_to(:body) }
      it { is_expected.to respond_to(:headers) }
    end
  end
end