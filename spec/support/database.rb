# frozen_string_literal: true

require "active_record"

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users do |t|
    t.column :name, :string
  end
end

class User < ActiveRecord::Base; end
