# rspec spec/transact_pro/response_spec.rb
RSpec.describe TransactPro::Response do
  include RemoteMockHelpers

  let(:response) { described_class.new(body) }

  describe "#to_s" do
    let(:body) { "OK:b327adac3953bc768442ff75315c83400fa55433~" }

    it "returns the raw response body" do
      expect(response.to_s).to eq(body)
    end
  end

  describe "#to_h" do
    subject(:hash) { response.to_h }

    context "when called on an OK :init response" do
      let(:body) { RemoteMockHelpers:: MOCK_INIT_BODY }

      it "hashifies the body" do
        expect(hash).to eq({
          "OK" => "b327adac3953bc768442ff75315c83400fa55433",
          "RedirectOnsite" => (
            "https://gw2sandbox.tpro.lv:8443/gw2test/ccdata.php?"\
            "tid=552c198cdc2b0b60c232bc48e1469b01"
          )
        })
      end
    end

    context "when called on an ERROR :init response" do
      let(:body) { RemoteMockHelpers::MOCK_INIT_ERROR_BODY }

      it "hashifies the one ERROR key of the body" do
        expect(hash).to eq({
          "ERROR" => (
            "1514991412.8734:{CODE:0013}Init failed: bad transaction data: "\
            "[\"Bad email passed by merchant '776' : 'NA'\"]:"
          )
        })
      end
    end

    context "when called on an OK :charge_recurring response" do
      let(:body) { RemoteMockHelpers::MOCK_CHARGE_RECURRENT_BODY }

      it "hashifies the body" do
        expect(hash).to eq({
          "ID" => "12f880aaec6001a7cb39e94858f1f9d9a06b461c",
          "Status" => "Success",
          "MerchantID" => "c9acc80e-4e1a-45fe-a741-0f78dd5886d7",
          "Terminal" => "Non 3D",
          "ResultCode" => "000",
          "ExtendedErrorCode" => "not set",
          "MerchantReferringName" => "",
          "DynamicDescriptor" => "",
          "StatusID" => "7",
          "CardIssuerCountry" => "XX",
          "NameOnCard" => "B Fisher",
          "CardMasked" => "5413********0019",
          "ResultCodeStr" => "Approved",
          "ProcessorError" => "",
          "CardSaveStatus" => "5",
          "mdErrorMessage" => "no data",
          "email" => "john_doe@example.com"
        })
      end
    end
  end

  describe "#redirect_link" do
    subject(:redirect_link) { response.redirect_link }

    context "when called on an init response with a link" do
      let(:body) { RemoteMockHelpers::MOCK_INIT_BODY }

      it "returns the link in the response" do
        expect(redirect_link).to match(
          %r"
            https://gw2sandbox\.tpro\.lv:8443/gw2test/ccdata\.php\?
            tid=552c198cdc2b0b60c232bc48e1469b01
          "x
        )
      end
    end

    context "when called on a response withouth a link" do
      let(:body) { RemoteMockHelpers::MOCK_INIT_ERROR_BODY }

      it { is_expected.to be_nil }
    end
  end

  describe "#status" do
    subject(:status) { response.status }

    context "when called on an OK response" do
      let(:body) { RemoteMockHelpers::MOCK_INIT_BODY }

      it { is_expected.to eq("OK") }
    end

    context "when called on an OK payment response" do
      let(:body) { RemoteMockHelpers::MOCK_CHARGE_RECURRENT_BODY }

      it { is_expected.to eq("OK") }
    end

    context "when called on an ERROR response" do
      let(:body) { RemoteMockHelpers::MOCK_INIT_ERROR_BODY }

      it { is_expected.to eq("ERROR") }
    end

    context "when called on a response that does not conform to expectations" do
      let(:body) { "" }

      it { is_expected.to eq("ERROR") }
    end
  end

  describe "#tid" do
    subject(:tid) { response.tid }

    context "when called on an OK :init response" do
      let(:body) { RemoteMockHelpers::MOCK_INIT_BODY }

      it "returns the transaction ID portion of the response" do
        expect(tid).to(
          eq("b327adac3953bc768442ff75315c83400fa55433")
        )
      end
    end

    context "when called on an :init ERROR response" do
      let(:body) { RemoteMockHelpers::MOCK_INIT_ERROR_BODY }

      it { is_expected.to be_nil }
    end

    context "when called on an :init_recurrant ERROR response" do
      let(:body) { RemoteMockHelpers::MOCK_INIT_RECURRENT_ERROR_BODY }

      it { is_expected.to be_nil }
    end
  end

end
