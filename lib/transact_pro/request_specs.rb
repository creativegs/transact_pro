module TransactPro
  module RequestSpecs
    # Contants ending with _SPEC here describe the request body fields
    # (whether the field is mandatory and supposed format)

    # set of allowed characters:
	  # a: alphabetic characters are the upper case letters A through Z; the lower case letters a through z, and the blank (space) character.
    #	h: hexadecimal number.
	  # n: numeric characters are the numbers zero (0) through nine (9).
	  # s: special printable characters are any printable characters that are neither alphabetic nor numeric,
    #    have an ASCII hexadecimal value greater than 20, or an EBCDIC hexadecimal value greater than 40.
    #    Occurrences of values ASCII 00 – 1F and EBCDIC 00 – 3F are not valid. Not all special characters are
    #    usually enabled. See fields’ description for details."
    # u: Unicode alphabetic characters.

    GUID_REGEX = %r'\A[[:alnum:]]{4}-[[:alnum:]]{4}-[[:alnum:]]{4}-[[:alnum:]]{4}\z'
    PASSWORD_DIGEST_REGEX = %r'\A.{40}\z'
    ROUTING_REGEX = %r'\A[[:alnum:]]{1,12}\z' # an(1..12)
    MERCHANT_TRANSACTION_ID = %r'\A.{5,50}\z' # ans(5..50)
    TID_REGEX = %r'\A[0-9a-f]{40}\z'i # h(40)
    USER_IP = %r'\A
      (
        ([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.
      ){3}
      ([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])
    \z'x # ns(7..15)
    DESCRIPTION = %r'\A.{5,255}\z' # uns(5..255)
    AMOUNT = %r'\A[1-9]\d*\z' # n
    CURRENCY = %r'\A[[:upper:]]{3}\z' # a(3)
    NAME_ON_CARD = %r'\A.{2,100}\z' # ans(2..100)
    STREET = %r'\A.{2,50}\z' # ans(2..50)
    ZIP = %r'\A.{2,15}\z' # ans(2..15)
    CITY = %r'\A.{2,25}\z' # ans(2..25)
    COUNTRY = %r'\A[[:alpha:]]{2}\z' # a(2)
    STATE = %r'\A.{2,20}\z' # ans(2..20)
    EMAIL = %r'\A.{1,100}\z' # ans(1..100)
    PHONE = %r'\A[0-9\-_]{5,25}\z' # ns(5..25)
    CARD_BIN = %r'\A\d{6}\z' # n(6)
    BIN_NAME = %r'\A.{3,50}\z' # uns(3..50)
    BIN_PHONE = %r'\A[0-9\-_]{3,25}\z' # ns(3..25)
    MERCHANT_SITE_URL = %r'\A.{1,255}\z' # ans(1..255)
    MERCHANT_REFERRING_NAME = %r'\A.{1,21}\z' # ans(1..21)
    BACK_URL = %r'\A.{1,255}\z' # ans(1..255)
    F_EXTENDED = %r'\A\d+\z' # n

    # 10. Table
    # Field Format Description
    # guid ans(19) Your merchant GUID.
    # pwd h(40) SHA1 hash of your processing password.
    # rs an(1..12) Your routing string.
    # merchant_transaction_id ans(5..50) Your transaction ID, must be unique for every transaction you submit to
    # the gateway. The transaction ID must be from 5 to 50 characters.
    # user_ip ns(7..15) Cardholder's IP, as string (AA.BB.CC.DD).
    # description uns(5..255) Order items description, from 5 to 255 characters (Example: SDHC
    # Memory card x 2, AAA battery pack x 1).
    # amount n Transaction amount, in MINOR units (i.e. 2150 for $21.50 transaction).
    # Notice: check JPY exception notice below!
    # currency a(3) Transaction currency, ISO 4217 3-character code, USD, EUR, CHF etc.
    # name_on_card ans(2..100) Cardholder name, as printed on a card (pass client name if card data
    # collected at gateway side)
    # street ans(2..50) Cardholder address – street. (min 2 symbols)
    # zip ans(2..15) Cardholder address – ZIP. (min 2 symbols)
    # city as(2..25) Cardholder address – City. (min 2 symbols)
    # country a(2) Cardholder address – country, 2-letter ISO 3166-1-Alpha 2 code.
    # state ans(2..20) Cardholder address – state (send NA if you don't have state information).
    # email ans(1..100) Cardholder address – email
    # phone ns(5..25) Cardholder phone number (min. 5 symbols).
    # card_bin n(6) Cardholder card BIN (first 6 characters of CC number). - not required if
    # card data collected at gateway side.
    # bin_name uns(3..50) Cardholder bank name (non-mandatory).
    # bin_phone ns(3..25) Cardholder bank phone given on a back side of used card
    # (non-mandatory).
    # merchant_site_url ans(1..255) Purchase site URL.
    # merchant_referring_name ans(1..21) Must not be send by default. See chapter 3.5 for description if you need
    # to use it.
    # custom_return_url ans(1..255) Custom return URL
    # custom_callback_url ans(1..255) Custom callback URL
    INIT_SPEC = {
      # method: :init
      guid: {mandatory: true, format: GUID_REGEX},
      pwd: {mandatory: true, format: PASSWORD_DIGEST_REGEX},
      rs: {mandatory: true, format: ROUTING_REGEX},
      merchant_transaction_id: {mandatory: true, format: MERCHANT_TRANSACTION_ID},
      user_ip: {mandatory: true, format: USER_IP},
      description: {mandatory: true, format: DESCRIPTION},
      amount: {mandatory: true, format: AMOUNT},
      currency: {mandatory: true, format: CURRENCY},
      name_on_card: {mandatory: true, format: NAME_ON_CARD},
      street: {mandatory: true, format: STREET},
      zip: {mandatory: true, format: ZIP},
      city: {mandatory: true, format: CITY},
      country: {mandatory: true, format: COUNTRY},
      state: {mandatory: true, format: STATE},
      email: {mandatory: true, format: EMAIL},
      phone: {mandatory: true, format: PHONE},
      card_bin: {mandatory: false, format: CARD_BIN},
      bin_name: {mandatory: false, format: BIN_NAME},
      bin_phone: {mandatory: false, format: BIN_PHONE},
      merchant_site_url: {mandatory: true, format: MERCHANT_SITE_URL},
      merchant_referring_name: {mandatory: false, format: MERCHANT_REFERRING_NAME},
      custom_return_url: {mandatory: false, format: BACK_URL},
      custom_callback_url: {mandatory: false, format: BACK_URL}
    }.freeze

    INIT_DEFAULTS = {
      name_on_card: "John Doe",
      street: "NA", zip: "NA", city: "NA", country: "NA", state: "NA",
      email: "john_doe@example.com", phone: "00371000000"
    }.freeze

    INIT_RECURRING_REGISTRATION_SPEC = INIT_SPEC.
      # method: :init_recurring_registration
      dup.merge(save_card: {mandatory: true, format: %r'\d+'}).freeze
    INIT_RECURRING_REGISTRATION_DEFAULTS = INIT_DEFAULTS.
      dup.merge(save_card: "1").freeze

    # 32. Table
    # Field Format Description
    # guid ans(19) Your merchant GUID
    # pwd h(40) SHA1 hash of your processing password
    # rs an(1..12) Routing string
    # original_init_id h(40) init_transaction_id of your original transaction
    # merchant_transaction_id ans(5..50) Your transaction ID
    # amount n Transaction amount, in MINOR units (i.e. 2150 for $21.50 transaction)
    # description uns(5..255) Order items description
    INIT_RECURRENT_SPEC = {
      # method: :init_recurrent
      guid: {mandatory: true, format: GUID_REGEX},
      pwd: {mandatory: true, format: PASSWORD_DIGEST_REGEX},
      rs: {mandatory: true, format: ROUTING_REGEX},
      original_init_id: {mandatory: true, format: TID_REGEX},
      merchant_transaction_id: {mandatory: true, format: MERCHANT_TRANSACTION_ID},
      amount: {mandatory: true, format: AMOUNT},
      description: {mandatory: true, format: DESCRIPTION},
    }.freeze

    INIT_RECURRENT_DEFAULTS = {
      # none
    }.freeze

    # 34. Table
    # Field Format Description
    # init_transaction_id h(40) init_transaction_id received for this recurrent transaction
    # f_extended n Return extended charge details (optional)
    CHARGE_RECURRENT_SPEC = {
      # method: :charge_recurrent
      guid: {mandatory: true, format: GUID_REGEX},
      pwd: {mandatory: true, format: PASSWORD_DIGEST_REGEX},
      init_transaction_id: {mandatory: true, format: TID_REGEX},
      f_extended: {mandatory: false, format: F_EXTENDED},
    }.freeze

    CHARGE_RECURRENT_DEFAULTS = {
      f_extended: "100" # determines the verbosity of responses
    }.freeze

    # 19. Table
    # Field Format Value
    # request_type as 'transaction_status'
    # init_transaction_id h(40) Gateway Transaction ID
    # f_extended n Return extended charge details, see section 2.4 of this manual for more details
    # (optional)
    # guid ans(19) Your GUID
    # pwd h(40) SHA1 hash of your processing password
    STATUS_REQUEST_SPEC = {
      # method: :status_request
      guid: {mandatory: true, format: GUID_REGEX},
      pwd: {mandatory: true, format: PASSWORD_DIGEST_REGEX},
      request_type: {mandatory: true, format: 'transaction_status'},
      init_transaction_id: {mandatory: true, format: TID_REGEX},
      f_extended: {mandatory: false, format: F_EXTENDED}
    }.freeze

    STATUS_REQUEST_DEFAULTS = {
      request_type: 'transaction_status',
      f_extended: "100", # determines the verbosity of responses
    }.freeze
  end
end
