class TransactPro::Request
  class ValidationError < RuntimeError
  end

  SUPPORTED_METHODS = %i|
    init init_store_card_sms init_recurrent charge_recurrent status_request
    refund
  |.freeze

  RECURRING_METHODS = %i|init_recurrent charge_recurrent|.freeze

  attr_reader :options, :method

  # Do not use this default initializer!
  # Instead, initialize a Gateway and call #request method on that.
  def initialize(options)
    @options = options
    @method = @options[:method]

    unless SUPPORTED_METHODS.include?(@method)
      raise ArgumentError.new(
        "'#{@method}' is not a supported API request method"
      )
    end

    # will be handled in validation loop
    # if @method == :init_recurrent && @options[:ACCOUNT_RECURRING].to_s.size < 1
    #   raise ArgumentError.new(
    #     ":#{@method} request requires a ACCOUNT_RECURRING "\
    #     "to be configured on the gateway"
    #   )
    # end
  end

  def call
    @defaults ||= TransactPro::RequestSpecs.const_get(
      "#{method.to_s.upcase}_DEFAULTS"
    )

    @request_options ||= @defaults.merge(options)
    @request_options[:rs] = routing_string

    @spec ||= TransactPro::RequestSpecs.const_get(
      "#{method.to_s.upcase}_SPEC"
    )

    @postable_params = {}
    @spec.each do |k, spec|
      do_validation =
        if spec[:mandatory]
          # mandatory key, always validate
          @postable_params[k] = @request_options[k]
          true
        else
          # non-mandatory key, include and validate only if it is present
          if @request_options[k].to_s.size > 0
            @postable_params[k] = @request_options[k]
            true
          else
            false
          end
        end

      validate(k, @postable_params[k], spec[:format]) if do_validation
    end

    @url = "#{@request_options[:API_URI]}?a=#{method}"

    binding.pry

    @response = RestClient.post(@url, @postable_params)
  end

  private
    def validate(key, string, regex)
      unless string[regex]
        raise TransactPro::Request::ValidationError.new(
          ":#{key} with value '#{string}' is invalid for request, "\
          "expected a match for regex #{regex.inspect}"
        )
      end
    end

    def routing_string
      @routing_string =
        if options[:rs].to_s.size > 0
          options[:rs]
        elsif recurring_method?
          options[:ACCOUNT_RECURRING]
        else
          # a regular user-facing method, preferring 3D account
          options[:ACCOUNT_3D].to_s.size > 0 ?
            options[:ACCOUNT_3D] :
            ptions[:ACCOUNT_NON3D]
        end
    end

    def recurring_method?
      RECURRING_METHODS.include?(method)
    end

end
