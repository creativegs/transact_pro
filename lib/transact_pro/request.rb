class TransactPro::Request
  class ValidationError < RuntimeError
  end

  SUPPORTED_METHODS = %i|
    init init_recurring_registration init_recurrent charge_recurrent
    status_request
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
  end

  def call
    # does prep
    details

    @raw_response = RestClient.post(@url, @postable_params)
    @response = TransactPro::Response.new(@raw_response.to_s)
  end

  def details
    return @details if defined?(@details)

    # DEPRECATED
    @defaults ||= TransactPro::RequestSpecs.const_get(
      "#{method.to_s.upcase}_DEFAULTS"
    )

    @request_options ||= @defaults.merge(options)
    @request_options[:rs] = routing_string

    @spec ||= spec_to_use

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

    @url = "#{@request_options[:API_URI]}?a=#{sendable_method}"

    @details = {url: @url, params: @postable_params}
  end

  private

    def validate(key, string, regex)
      unless string.to_s[regex]
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
            options[:ACCOUNT_NON3D]
        end
    end

    def recurring_method?
      RECURRING_METHODS.include?(method)
    end

    def sendable_method
      method == :init_recurring_registration ? :init : method
    end

    def spec_to_use
      const =
        if options[:LOOSENED_VALIDATIONS]
          loosened_const = "LOOSENED_#{method.to_s.upcase}_SPEC" #=> "LOOSENED_INIT_SPEC"

          if defined?(loosened_const)
            loosened_const
          else
            "#{method.to_s.upcase}_SPEC"
          end
        else
          "#{method.to_s.upcase}_SPEC"
        end

      TransactPro::RequestSpecs.const_get(const) #=> "INIT_SPEC"
    end

end
