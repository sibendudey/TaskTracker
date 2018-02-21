use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :tasktracker, TasktrackerWeb.Endpoint,
  secret_key_base: "5XjopekeKQCVXUe96GqskGaUKLfzjdDE11Ttf3TH3LeDi5Z/5eg484AJR/KmKmGi"

# Configure your database
config :tasktracker, Tasktracker.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "tasktracker",
  password: "doodeesaed1I",
  database: "tasktracker_prod",
  pool_size: 15
