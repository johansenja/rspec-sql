# frozen_string_literal: true

require "active_support"
require "rspec"

require_relative "sql/query_summary"

# We are building within the RSpec namespace for consistency and convenience.
# We are not part of the RSpec team though.
module RSpec
  # RSpec::Sql contains our code.
  module Sql; end

  Matchers.define :query_database do |expected = nil|
    match do |block|
      @queries = scribe_queries(&block)

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

    failure_message do |_block|
      if expected.is_a?(Enumerator) && expected.inspect.match?(/:times>$/)
        expected = expected.size
      end

      <<~MESSAGE
        Expected database queries: #{expected}
        Actual database queries:   #{query_names}

        Diff: #{Expectations.differ.diff_as_object(query_names, expected)}

        Full query log:

        #{query_descriptions.join("\n")}
      MESSAGE
    end

    failure_message_when_negated do |_block|
      <<~TXT
        Expected no database queries but observed:

        #{query_descriptions.join("\n")}
      TXT
    end

    def supports_block_expectations?
      true
    end

    def query_names
      @queries.map { |q| q[:name] || q[:sql].split.take(2).join(" ") }
    end

    def query_descriptions
      @queries.map { |q| "#{q[:name]}  #{q[:sql]}" }
    end

    def query_summary
      Sql::QuerySummary.new(@queries).summary
    end

    def scribe_queries(&)
      queries = []

      logger = lambda do |_name, _started, _finished, _unique_id, payload|
        queries << payload unless %w[CACHE SCHEMA].include?(payload[:name])
      end

      ActiveSupport::Notifications.subscribed(logger, "sql.active_record", &)

      queries
    end
  end
end
