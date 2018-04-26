# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

use Mix.Config

# General application configuration # Remove this and the following two lines, elminiating ecto Repo
# config :phoenixDSK3LO,
#   ecto_repos: [PhoenixDSK3LO.Repo]

# Configures the endpoint
config :phoenixDSK3LO, PhoenixDSK3LO.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "NbUbqH0HknnAKz2Oj75sB6wg7udOvUwTbJJuRzrNEOtKSGjo+X6eWeslQ52h03PF",
  render_errors: [view: PhoenixDSK3LO.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhoenixDSK3LO.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Add this applications config to the endpoint
  config :phoenixDSK3LO, PhoenixDSK3LO.Endpoint,
    learnserver: "bd-partner-a-original-new.blackboard.com",
    learnserverAtom: String.to_atom("bd-partner-a-original-new.blackboard.com")

# Configures Elixir's

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
