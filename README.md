# dm4sea
DataMatrix for Sea Vision Serialization System

# Test
Before running RSpec the database has to be created with `bundle exec rake db:create['test']`.
The test environment needs the RECIPIENTS env variable to be defined (put it on `.env`).

# CI Environment
The CI environment needs the RECIPIENTS env variable to be defined (put it on `env.ci.encrypted`).
