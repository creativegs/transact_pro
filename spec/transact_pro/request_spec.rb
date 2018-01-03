# rspec spec/transact_pro/request_spec.rb
RSpec.describe TransactPro::Request do
  include GatewayHelpers
  include RequestHelpers

  describe "#initialize" do
    subject(:request) { described_class.new(options) }

    let(:options) do
      {
        API_URI: "https://www2.1stpayments.net/gwprocessor2.php",
        pwd: "7a2a972a49ce2db9172f9017843f6076f5177296",
        guid: "CAZY-7319-WI00-0C40",
        GUID: "CAZY-7319-WI00-0C40",
        PASSWORD: "g44B/pAENO2E",
        ACCOUNT_3D: "CS01",
        ACCOUNT_NON3D: "CS02",
        ACCOUNT_RECURRING: "CS03",
        method: :status_request,
      }
    end

    context "when called with OK request options" do
      it "returns a Request instance" do
        expect(request).to be_a(described_class)
      end
    end

    context "when called with an unsupported :method key" do
      let(:options) { super().merge(method: :noop) }

      it "raises an ArgumentError" do
        expect{ request }.to(
          raise_error(ArgumentError, %r"':noop' is not a supported API request method")
        )
      end
    end

    context "when called with a :method key that requires a missing account type" do
      let(:options) { super().merge(method: :init_recurrent, ACCOUNT_RECURRING: "") }

      it "raises an ArgumentError" do
        expect{ request }.to(
          raise_error(ArgumentError, %r":init_recurrent request requires a ACCOUNT_RECURRING to be configured on the gateway")
        )
      end
    end

  end

  describe "#call" do
    subject(:make_remote_request) { request.call }

    let(:request) { sandbox_gateway.request(request_options) }

    context "when called on a :init request" do
      let(:request_options) { init_request_options }

      before { mock_init }

      context "and it is valid" do
        it "makes a remote request and returns the response object" do
          expect(make_remote_request).to be_a(String)
          expect(make_remote_request).to match(%r'Fff')
        end
      end

      context "and it is invalid" do
        let(:request_options) { super().merge(merchant_transaction_id: "1234") }

        it "raises a TransactPro::Request::ValidationError" do
          expect{ make_remote_request }.to(
            raise_error(
              TransactPro::Request::ValidationError,
              %r"merchant_transaction_id\swith\svalue\s'1234'\sis\sinvalid"xo
            )
          )
        end
      end

      context "and remote returns an error response" do
        let(:request_options) { super().merge(email: "NA") }

        before { mock_init_error }

        it "raises a TransactPro::Request::ValidationError" do
          expect{ make_remote_request }.to(
            raise_error(
              TransactPro::Request::ValidationError,
              %r"merchant_transaction_id\swith\svalue\s'1234'\sis\sinvalid"xo
            )
          )
        end
      end

    end

  end

end
