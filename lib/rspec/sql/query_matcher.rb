# frozen_string_literal: true

require_relative "query_summary"

module RSpec
  module Sql
    # Compares expectations with actual queries.
    class QueryMatcher
      def initialize(queries, expected)
        @queries = queries
        @expected = sanitize_number(expected)
      end

      def matches?
        # Simple presence validation.
        return !@queries.empty? if expected.nil?

        actual == expected
      end

      private

      attr_reader :expected

      # Support writing: `is_expected.to query_database 5.times`
      def sanitize_number(expected)
        if expected.is_a?(Enumerator) && expected.inspect.match?(/:times>$/)
          expected.size
        else
          expected
        end
      end

      def actual
        @actual ||= actual_compared_to_expected
      end

      def actual_compared_to_expected
        case expected
        when Integer
          @queries.size
        when Array
          query_names
        when Hash
          query_summary
        else
          raise "What are you expecting?"
        end
      end

      def query_names
        @queries.map { |q| q[:name] || q[:sql].split.take(2).join(" ") }
      end

      def query_summary
        QuerySummary.new(@queries).summary
      end
    end
  end
end
