# rspec-sql

RSpec matcher for database queries

## Installation

```rb
# Gemfile
gem "rspec-sql"
```

## Usage

```rb
# Assert any database queries:
expect { User.last }.to query_database

# Assert no database queries:
expect { nil }.to_not query_database

# Assert exactly one query:
expect { User.last }.to query_database 1

# Assert specific queries:
expect { User.last }.to query_database ["User Load"]

expect { User.create!.update(name: "Jane") }.to query_database [
  "TRANSACTION",
  "User Create",
  "TRANSACTION",
  "TRANSACTION",
  "User Update",
  "TRANSACTION",
]
```

## Alternatives

If you are more interested in the number of specific queries then have a look
at these other gems:

- https://github.com/nepalez/rspec-sqlimit
- https://github.com/sds/db-query-matchers
