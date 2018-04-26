use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :phoenixDSK3LO, PhoenixDSK3LO.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../", __DIR__)]]


# Watch static and templates for browser reloading.
config :phoenixDSK3LO, PhoenixDSK3LO.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]
# This Learn REST Application's Key and secret
# These are held by the application developer and not to be
# shared outside that organization. Otherwise someone can
# spoof your application. Read these with:
# Application.get_env(:phoenixDSK3LO, PhoenixDSK3LO.Endpoint)[:appkey]
config :phoenixDSK3LO, PhoenixDSK3LO.Endpoint,
  appkey: "d0000000-000e-0000-00000000000000001",
  appsecret: "00000000000000000000000000000000",
  phoenix_dsk_user: "user3",
  phoenix_dsk_pwd: "secret3"

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20
