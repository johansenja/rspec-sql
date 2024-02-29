# frozen_string_literal: true

module RSpec
  module Sql
    class QuerySummary
      QUERY_TYPES = [:delete, :insert, :select, :update].freeze

      attr_reader :summary

      def initialize(queries)
        @summary = {}
        queries.each do |payload|
          type = get_type(payload[:sql])
          next if QUERY_TYPES.exclude?(type) || pg_query?(payload[:sql])

          table = get_table(payload[:sql])
          @summary[type] ||= {}
          @summary[type][table] ||= 0
          @summary[type][table] += 1
        end
      end

      private

      def get_table(sql)
        sql_parts = sql.split
        case get_type(sql)
        when :insert
          sql_parts[2]
        when :update
          sql_parts[1]
        else
          table_index = sql_parts.index("FROM")
          sql_parts[table_index + 1]
        end.gsub(/(\\|")/, "").to_sym
      end

      def get_type(sql)
        sql.split[0].downcase.to_sym
      end

      def pg_query?(sql)
        sql.include?("SELECT a.attname") || sql.include?("pg_attribute")
      end
    end
  end
end
