module RemoteMockHelpers
  def mock_init(options={})
    WebMock.stub_request(
      :post, "https://www2.1stpayments.net/gwprocessor2.php?a=init"
    ).with(
      body: anything,
      headers: anything
    ).to_return(
      status: 200,
      body: (
        "OK:b327adac3953bc768442ff75315c83400fa55433~"\
        "RedirectOnsite:https://gw2sandbox.tpro.lv:8443/gw2test/ccdata.php?"\
        "tid=552c198cdc2b0b60c232bc48e1469b01"
      ),
      headers: {}
    )
  end

  def mock_init_error(options={})
    WebMock.stub_request(
      :post, "https://www2.1stpayments.net/gwprocessor2.php?a=init"
    ).with(
      body: anything,
      headers: anything
    ).to_return(
      status: 200,
      body: (
        "ERROR:1514991412.8734:{CODE:0013}Init failed: bad transaction data: "\
        "[\"Bad email passed by merchant '776' : 'NA'\"]:"
      ),
      headers: {}
    )
  end

  def mock_init_store_card_sms(options={})

  end

  def mock_init_recurrent(options={})

  end

  def mock_charge_recurrent(options={})

  end

  def mock_status_request(options={})

  end

  def mock_refund(options={})

  end
end
