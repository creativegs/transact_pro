# rspec spec/transact_pro/gateway_spec.rb
RSpec.describe TransactPro::Gateway do
  include GatewayHelpers

  describe "#initialize" do
    subject(:gateway) { described_class.new(options) }

    let(:options) { sandbox_gateway_options }

    context "when called with an OK set of options" do
      it "returns a Gateway instance" do
        expect(gateway).to be_a(described_class)
      end
    end

    context "when options do not contain a valid :GUID" do
      let(:options) { super().merge(GUID: "oops") }

      it "raises an ArgumentError" do
        expect{ gateway }.to(
          raise_error(ArgumentError, %r"'oops' is not a valid GUID for a gateway")
        )
      end
    end

    context "when options do not contain a valid :PASSWORD" do
      let(:options) { super().merge(PASSWORD: "") }

      it "raises an ArgumentError" do
        expect{ gateway }.to(
          raise_error(ArgumentError, %r"'' is not a valid PASSWORD for a gateway")
        )
      end
    end

    context "when options do not contain valid routing string keys" do
      let(:options) { super().merge(ACCOUNT_3D: "", ACCOUNT_NON3D: "") }

      it "raises an ArgumentError" do
        expect{ gateway }.to(
          raise_error(ArgumentError, %r"As a minimum specify a ACCOUNT_3D or a ACCOUNT_NON3D for a gateway")
        )
      end
    end

  end

  describe "#request(request_options)" do
    subject(:request) { gateway.request(request_options) }

    let!(:gateway) { sandbox_gateway }
    let(:request_options) do
      {
        method: :status_request,
        request_type: 'transaction_status',
        init_transaction_id: "abc123",
        guid: "...",
        # pwd: "..."
      }
    end

    it "calls TransactPro::Request.new with merged options" do
      expect(TransactPro::Request).to(
        receive(:new).with(hash_including(
          pwd: "7a2a972a49ce2db9172f9017843f6076f5177296", # from gateway defaults
          guid: "...", # overridden with request options
          method: :status_request
        )).once
      )

      request
    end

  end
end
