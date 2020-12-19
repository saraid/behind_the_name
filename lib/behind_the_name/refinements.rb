require 'json'
require 'rest-client'

module BehindTheName
  module Refinements
    refine RestClient::Response do
      def parse_as_json
        body.parse_as_json
      end
    end

    refine String do
      def parse_as_json
        JSON.parse(self, symbolize_names: true)
      end
    end

    refine Hash do
      def compact
        reject { |_, v| v.nil? }
      end

      def to_uri_query
        self
          .compact
          .map { |k, v| "#{URI.escape(k.to_s)}=#{v}" }
          .join('&')
      end
    end
  end
end
