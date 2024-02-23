# frozen_string_literal: true

require "rspec/sql"
require_relative "../../support/database"

RSpec.describe RSpec::Sql do
  include RSpec::Sql

  it "expects database queries" do
    expect { User.last }.to query_database
  end

  it "raises without database queries" do
    expect {
      expect { nil }.to query_database
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it "expects no database queries" do
    expect { nil }.to_not query_database
  end

  it "expects no database queries" do
    expect { nil }.to query_database 0

    expect {
      expect { nil }.to query_database 1
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it "expects a number of database queries" do
    expect { User.last }.to query_database 1

    expect {
      expect { User.last }.to query_database 2
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it "shows which queries were executed" do
    expect {
      expect { User.connection.execute("SELECT 1") }.to query_database []
    }.to raise_error match("SELECT 1")
  end

  it "expects certain queries" do
    expect { User.last }.to query_database ["User Load"]
  end
end
