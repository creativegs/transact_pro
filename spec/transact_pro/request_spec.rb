# rspec spec/transact_pro/request_spec.rb
RSpec.describe TransactPro::Request do
  include GatewayHelpers
  include RequestHelpers
  include RemoteMockHelpers

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
          raise_error(ArgumentError, %r"'noop' is not a supported API request method")
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

      context "when an explicit :rs is passed in request options" do
        let(:request_options) { super().merge(rs: "CS04") }

        it "prefers a passed :rs key to the default" do
          make_remote_request

          expect(request.instance_variable_get("@routing_string")).to eq(
            "CS04"
          )
        end
      end

      context "and it is valid" do
        it "makes a remote request and returns the response object" do
          expect(make_remote_request).to be_a(TransactPro::Response)
          expect(make_remote_request.status).to eq("OK")
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

      context "and it passes amount below the 100 minimum specified in docs page 9" do
        let(:request_options) { super().merge(amount: "1") }

        it "does not raise a TransactPro::Request::ValidationError, allowing to charge cents" do
          expect{ make_remote_request }.to_not(
            raise_error(TransactPro::Request::ValidationError)
          )
        end
      end

      context "and remote returns an error response" do
        let(:request_options) { super().merge(email: "NA") }

        before { mock_init_error }

        it "returns the response object" do
          expect(make_remote_request).to be_a(TransactPro::Response)
          expect(make_remote_request.status).to eq("ERROR")
        end
      end

    end

    context "when called on a :init_recurring_registration request" do
      let(:request_options) { init_recurring_registration_request_options }

      before { mock_init_recurring_registration }

      context "and it is valid" do
        it "makes a remote request and returns the response object" do
          expect(make_remote_request).to be_a(TransactPro::Response)
          expect(make_remote_request.status).to eq("OK")
        end
      end

      context "and remote returns an error response" do
        let(:request_options) { super().merge(email: "NA") }

        before { mock_init_recurring_registration_error }

        it "returns the response object" do
          expect(make_remote_request).to be_a(TransactPro::Response)
          expect(make_remote_request.status).to eq("ERROR")
        end
      end
    end

    context "when called on a :init_recurrent request" do
      let(:request_options) { init_recurrent_request_options }

      before { mock_init_recurrent }

      context "and it is valid" do
        # NB, this will fail in live sandbox because a registration transaction is needed
        it "makes a remote request and returns the response object" do
          expect(make_remote_request).to be_a(TransactPro::Response)
          expect(make_remote_request.status).to eq("OK")
        end
      end

      context "and remote returns an error response" do
        let(:request_options) do
          # some nonexistat init_id
          super().merge(original_init_id: "b327adac3953bc768442ff75315c83400fa55433")
        end

        before { mock_init_recurrent_error }

        it "returns the response object" do
          expect(make_remote_request).to be_a(TransactPro::Response)
          expect(make_remote_request.status).to eq("ERROR")
        end
      end
    end

    context "when called on a :charge_recurrent request" do
      let(:request_options) { charge_recurrent_request_options }

      before { mock_charge_recurrent }

      context "and it is valid" do
        # NB, this will fail in live sandbox because a registration transaction is needed
        it "makes a remote request and returns the response object" do
          expect(make_remote_request).to be_a(TransactPro::Response)
          expect(make_remote_request.status).to eq("OK")
        end
      end

      context "and remote returns an error response" do
        let(:request_options) do
          super().merge(
            # some nonexistant TID
            init_transaction_id: "b327aaac3953bc768442ff75315c83400fa55433"
          )
        end

        before { mock_charge_recurrent_error }

        it "returns the response object" do
          expect(make_remote_request).to be_a(TransactPro::Response)
          expect(make_remote_request.status).to eq("ERROR")
        end
      end
    end

    context "when called on a :status_request request" do
      let(:request_options) { status_request_request_options }

      before { mock_status_request }

      context "and it is valid for a successful payment" do
        # NB, this will fail in live sandbox because a queryable transaction is needed
        it "makes a remote request and returns the response object" do
          expect(make_remote_request).to be_a(TransactPro::Response)
          expect(make_remote_request.status).to eq("OK")
          expect(make_remote_request.to_h["Status"]).to eq("Success")
        end
      end

      context "and it is valid for an unsuccessful payment" do
        before { mock_status_unsuccessful_request }

        it "returns the response object" do
          expect(make_remote_request).to be_a(TransactPro::Response)
          expect(make_remote_request.status).to eq("FAIL")
          expect(make_remote_request.to_h["Status"]).to eq("Failed")
        end
      end

      context "and remote returns an error response" do
        let(:request_options) do
          super().merge(
            # some nonexistant TID
            init_transaction_id: "b327aaac3953bc768442ff75315c83400fa5543a"
          )
        end

        before { mock_status_request_error }

        it "returns the response object" do
          expect(make_remote_request).to be_a(TransactPro::Response)
          expect(make_remote_request.status).to eq("ERROR")
        end
      end
    end

  end

  describe "#details" do
    subject(:details) { request.details }

    let(:request) { sandbox_gateway.request(request_options) }
    let(:request_options) { init_request_options }

    it "returns a hash of the :url and :params that will be used in request" do
      expect(details).to match({
        url: "https://www2.1stpayments.net/gwprocessor2.php?a=init",
        params: hash_including(guid: anything)
      })
    end
  end

end
