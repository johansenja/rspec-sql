# frozen_string_literal: true

require_relative "query_summary"

module RSpec
  module Sql
    # Compares expectations with actual queries.
    class QueryMatcher
      def initialize(queries)
        @queries = queries
      end

      def matches?(expected)
        if expected.nil?
          !@queries.empty?
        elsif expected.is_a?(Integer)
          @queries.size == expected
        elsif expected.is_a?(Enumerator) && expected.inspect.match?(/:times>$/)
          @queries.size == expected.size
        elsif expected.is_a?(Array)
          query_names == expected
        elsif expected.is_a?(Hash)
          query_summary == expected
        else
          raise "What are you expecting?"
        end
      end

      private

      def query_names
        @queries.map { |q| q[:name] || q[:sql].split.take(2).join(" ") }
      end

      def query_summary
        QuerySummary.new(@queries).summary
      end
    end
  end
end
