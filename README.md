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

# Assert exact number of queries:
expect { User.last }.to query_database 1
expect { User.create }.to query_database 3.times

# Assert a specific query list:
expect { User.last }.to query_database ["User Load"]

expect { User.create!.update(name: "Jane") }.to query_database [
  "TRANSACTION",
  "User Create",
  "TRANSACTION",
  "TRANSACTION",
  "User Update",
  "TRANSACTION",
]

# Assert a specific query summary:
expect { User.create!.update(name: "Jane") }.to query_database(
  {
    insert: { users: 1 },
    update: { users: 1 },
  }
)
```

## Alternatives

If you are more interested in the number of specific queries then have a look
at these other gems:

- https://github.com/nepalez/rspec-sqlimit
- https://github.com/sds/db-query-matchers
