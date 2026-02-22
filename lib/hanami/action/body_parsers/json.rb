# frozen_string_literal: true

require "json"
require_relative "../errors"

module Hanami
  class Action
    module BodyParsers
      # Body parser for JSON request bodies.
      #
      # @api private
      module JSON
        def self.call(body, env)
          ::JSON.parse(body)
        rescue ::JSON::ParserError => exception
          raise BodyParsingError, exception.message
        end
      end
    end
  end
end
