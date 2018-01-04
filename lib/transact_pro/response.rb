class TransactPro::Response
  attr_reader :body

  def initialize(body)
    @body = body
  end

  def to_s
    body
  end

  def to_h
    @to_h ||= body.split("~").inject({}) do |mem, portion|
      match = portion.match(%r'\A([^\:]+?)\:(.*)')
      mem[match[1]] = match[2]
      mem
    end
  end

  def redirect_link
    link_portion = body.split("~").detect do |portion|
      portion[%r'\ARedirectOnsite:']
    end

    link_portion.nil? ?
      nil :
      link_portion.match(%r'\ARedirectOnsite:(https?://.*?tid=[[:alnum:]]+)'i)[1]
  end

  def status
    status_portion = body.split("~").detect do |portion|
      portion[%r'\A(OK)|(Status)\:']
    end

    if status_portion.nil?
      "ERROR"
    elsif status_portion[%r'\AOK']
      "OK"
    elsif status_portion[%r'\AStatus']
      status = status_portion.match(%r'\AStatus:(.*)')[1]
      status == "Success" ? "OK" : "FAIL"
    else
      "ERROR"
    end
  end

  def tid
    tid_portion = body.split("~").detect do |portion|
      portion[%r'\AOK\:']
    end

    tid_portion.nil? ?
      nil :
      tid_portion.match(%r'\A(.*?)\:(.*)')[2]
  end

end
