require 'rest-client'
require 'json'
require "behind_the_name/refinements"
require "behind_the_name/usages"
require "behind_the_name/version"

module BehindTheName
  using Refinements

  class Error < StandardError; end

  singleton_class.class_eval do
    attr_writer :api_key

    def api_key
      (@api_key ||= ENV['BEHINDTHENAME_API_KEY']).tap do |key|
        raise 'Need an API KEY.' if key.nil?
      end
    end
  end

  def self.lookup(name:, exact: 'no')
    params = {
      name: name,
      exact: normalize_boolean(exact),
      key: api_key
    }

    RestClient.get(uri(:lookup), params: params).parse_as_json
  end

  def self.random(gender: nil, usage: nil, number: nil, randomsurname: nil)
    usage = validate_and_normalize_usage!(usage, :appendix2)
    validate_number!(number)

    params = {
      gender: normalize_gender(gender),
      usage: usage,
      number: number,
      randomsurname: normalize_boolean(randomsurname),
      key: api_key
    }.compact

    RestClient.get(uri(:random), params: params).parse_as_json
  end


  def self.related(name:, usage: nil, gender: nil)
    usage = validate_and_normalize_usage!(usage, :appendix1)

    params = {
      gender: normalize_gender(gender),
      usage: usage,
      key: api_key
    }.compact

    RestClient.get(uri(:related), params: params).parse_as_json
  end

  private_class_method def self.uri(endpoint)
    URI::HTTPS.build({ host: 'www.behindthename.com', path: "/api/#{endpoint}.json" }).to_s
  end

  class ParamError < Error; end
  private_class_method def self.validate_and_normalize_usage!(usage, appendix)
    return if usage.nil?
    Usages.from(appendix).normalize(usage)
  rescue Errno::ENOENT
    raise RuntimeError, 'Requested an appendix that does not exist.'
  rescue KeyError
    raise ParamError, "`#{usage.inspect}` is not a valid key for usage"
  end

  private_class_method def self.validate_number!(number)
    return if number.nil?
    unless number.kind_of?(Integer) && (1..6).include?(number)
      raise ParamError, "`#{number.inspect}` is not a valid key for numberi; " \
                        'try an integer between 1 and 6'
    end
  end

  private_class_method def self.normalize_gender(gender)
    return if gender.nil?
    case gender.to_sym
    when :m, :masculine then :m
    when :f, :feminine then :f
    when :u, :unisex then :u
    else raise ParamError, "`#{gender.inspect}` is not a valid key for gender; " \
                           'use :masculine, :feminine, or :unisex'
    end
  end

  private_class_method def self.normalize_boolean(boolean)
    case boolean
    when true, /^y/ then 'yes'
    else 'no'
    end
  end
end
