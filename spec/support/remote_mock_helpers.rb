module RemoteMockHelpers
  MOCK_INIT_BODY = (
    "OK:b327adac3953bc768442ff75315c83400fa55433~"\
    "RedirectOnsite:https://gw2sandbox.tpro.lv:8443/gw2test/ccdata.php?"\
    "tid=552c198cdc2b0b60c232bc48e1469b01"
  )

  MOCK_INIT_ERROR_BODY = (
    "ERROR:1514991412.8734:{CODE:0013}Init failed: bad transaction data: "\
    "[\"Bad email passed by merchant '776' : 'NA'\"]:"
  )

  # MOCK_INIT_RECURRING_REGISTRATION_BODY = # same as regular INIT

  MOCK_INIT_RECURRENT_BODY = "OK:12f880aaec6001a7cb39e94858f1f9d9a06b461c"
  MOCK_INIT_RECURRENT_ERROR_BODY = (
    "ERROR:1515060089.9121:{CODE:0012}"\
    "Init failed: Recurrent transaction init failed ('1' ''): "\
    "1515060089: (RecurrentPayment) 'Card data not saved for "\
    "original_init_id '5e3b2de954b4dd8e0e234f0e9c591bd1b7c5a6ae'':"
  ).freeze

  # NB, this verbose success response comes from f_extended: "100"
  MOCK_CHARGE_RECURRENT_BODY = (
    "ID:12f880aaec6001a7cb39e94858f1f9d9a06b461c~"\
    "Status:Success~"\
    "MerchantID:c9acc80e-4e1a-45fe-a741-0f78dd5886d7~"\
    "Terminal:Non 3D~"\
    "ResultCode:000~"\
    "ExtendedErrorCode:not set~"\
    "MerchantReferringName:~"\
    "DynamicDescriptor:~"\
    "StatusID:7~"\
    "CardIssuerCountry:XX~"\
    "NameOnCard:B Fisher~"\
    "CardMasked:5413********0019~"\
    "ResultCodeStr:Approved~"\
    "ProcessorError:~"\
    "CardSaveStatus:5~"\
    "mdErrorMessage:no data~"\
    "email:john_doe@example.com"
  ).freeze

  MOCK_CHARGE_RECURRENT_ERROR_BODY = (
    "ERROR:1515062241.2231:{CODE:0021}"\
    "Charge operation failed for "\
    "(passed: '12f880aaec6001a7cb39e94858f1f9d9a06b461f') '': "\
    "Bad init transaction ID:"
  )

  MOCK_STATUS_REQUEST_SINGLE_BODY = (
    "ID:125abd71be79b0650134e1e88b5f5f700effa832~"\
    "Status:Success~"\
    "MerchantID:0b40d7aa-c901-4ca9-b4ff-2fde0670da96~"\
    "Terminal:Test 3D~ResultCode:000~ExtendedErrorCode:not set~"\
    "MerchantReferringName:~DynamicDescriptor:~StatusID:7~"\
    "CardIssuerCountry:XX~NameOnCard:B Fisher~"\
    "CardMasked:5413********0019~ResultCodeStr:Approved~ProcessorError:~"\
    "CardSaveStatus:2~mdErrorMessage:Authenticated~email:john_doe@example.com"
  )

  MOCK_STATUS_REQUEST_SINGLE_FAIL_BODY = (
    "ID:5e3b2de954b4dd8e0e234f0e9c591bd1b7c5a6ae~"\
    "Status:Failed~"\
    "MerchantID:64e5b65f-9202-4b33-85a6-d198f692fc43~"\
    "Terminal:~"\
    "ResultCode:~"\
    "ExtendedErrorCode:Wrong IP passed to GW~"\
    "MerchantReferringName:~"\
    "DynamicDescriptor:~"\
    "StatusID:5~"\
    "CardIssuerCountry:XX~"\
    "NameOnCard:John Doe~"\
    "CardMasked:~"\
    "ResultCodeStr:No result code~"\
    "ProcessorError:~"\
    "CardSaveStatus:1~"\
    "mdErrorMessage:no data~email:john_doe@example.com"
  )

  MOCK_STATUS_REQUEST_RECURRING_BODY = (
    "ID:12f880aaec6001a7cb39e94858f1f9d9a06b461c~"\
    "Status:Success~"\
    "MerchantID:c9acc80e-4e1a-45fe-a741-0f78dd5886d7~"\
    "Terminal:Non 3D~"\
    "ResultCode:000~"\
    "ExtendedErrorCode:not set~"\
    "MerchantReferringName:~"\
    "DynamicDescriptor:~"\
    "StatusID:7~"\
    "CardIssuerCountry:XX~"\
    "NameOnCard:B Fisher~"\
    "CardMasked:5413********0019~"\
    "ResultCodeStr:Approved~"\
    "ProcessorError:~CardSaveStatus:5~mdErrorMessage:no data~"\
    "email:john_doe@example.com"
  )

  MOCK_STATUS_REQUEST_ERROR_BODY = (
    "ERROR:1515067319.9239:{CODE:0074}Status request failed: 1515067319: "\
    "(TransactionWrapper) 'Wrong init transaction ID' : '' <br>; :"
  )

  def mock_init(options={})
    WebMock.stub_request(
      :post, "#{TransactPro::DEFAULTS[:PRODUCTION_ENV][:API_URI]}?a=init"
    ).to_return(
      status: 200,
      body: MOCK_INIT_BODY,
      headers: {}
    )
  end

  def mock_init_error(options={})
    WebMock.stub_request(
      :post, "#{TransactPro::DEFAULTS[:PRODUCTION_ENV][:API_URI]}?a=init"
    ).to_return(
      status: 200,
      body: MOCK_INIT_ERROR_BODY,
      headers: {}
    )
  end

  def mock_init_recurring_registration(options={})
    WebMock.stub_request(
      :post, "#{TransactPro::DEFAULTS[:PRODUCTION_ENV][:API_URI]}?a=init"
    ).to_return(
      status: 200,
      body: MOCK_INIT_BODY,
      headers: {}
    )
  end

  def mock_init_recurring_registration_error(options={})
    WebMock.stub_request(
      :post, "#{TransactPro::DEFAULTS[:PRODUCTION_ENV][:API_URI]}?a=init"
    ).to_return(
      status: 200,
      body: MOCK_INIT_ERROR_BODY,
      headers: {}
    )
  end

  def mock_init_recurrent(options={})
    WebMock.stub_request(
      :post, "#{TransactPro::DEFAULTS[:PRODUCTION_ENV][:API_URI]}?a=init_recurrent"
    ).to_return(
      status: 200,
      body: MOCK_INIT_RECURRENT_BODY,
      headers: {}
    )
  end

  def mock_init_recurrent_error(options={})
    WebMock.stub_request(
      :post, "#{TransactPro::DEFAULTS[:PRODUCTION_ENV][:API_URI]}?a=init_recurrent"
    ).to_return(
      status: 200,
      body: MOCK_INIT_RECURRENT_ERROR_BODY,
      headers: {}
    )
  end

  def mock_charge_recurrent(options={})
    WebMock.stub_request(
      :post, "#{TransactPro::DEFAULTS[:PRODUCTION_ENV][:API_URI]}?a=charge_recurrent"
    ).to_return(
      status: 200,
      body: MOCK_CHARGE_RECURRENT_BODY,
      headers: {}
    )
  end

  def mock_charge_recurrent_error(options={})
    WebMock.stub_request(
      :post, "#{TransactPro::DEFAULTS[:PRODUCTION_ENV][:API_URI]}?a=charge_recurrent"
    ).to_return(
      status: 200,
      body: MOCK_CHARGE_RECURRENT_ERROR_BODY,
      headers: {}
    )
  end

  def mock_status_request(options={})
    WebMock.stub_request(
      :post, "#{TransactPro::DEFAULTS[:PRODUCTION_ENV][:API_URI]}?a=status_request"
    ).to_return(
      status: 200,
      body: MOCK_STATUS_REQUEST_SINGLE_BODY,
      headers: {}
    )
  end

  def mock_status_unsuccessful_request(options={})
    WebMock.stub_request(
      :post, "#{TransactPro::DEFAULTS[:PRODUCTION_ENV][:API_URI]}?a=status_request"
    ).to_return(
      status: 200,
      body: MOCK_STATUS_REQUEST_SINGLE_FAIL_BODY,
      headers: {}
    )
  end

  def mock_status_request_error(options={})
    WebMock.stub_request(
      :post, "#{TransactPro::DEFAULTS[:PRODUCTION_ENV][:API_URI]}?a=status_request"
    ).to_return(
      status: 200,
      body: MOCK_STATUS_REQUEST_ERROR_BODY,
      headers: {}
    )
  end

end
