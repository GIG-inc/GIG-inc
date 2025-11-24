import Config
config :project, ecto_repos: [Project.Repo]
# config :grpc, start_server: true
# config :project,  Comms.Endpoint,
#   port: 50052,
#   adapter: GRPC.Adapter.Cowboy,
#   cowboy_opts: []
config :project, Project.Eventstore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "admin",
  password: "changeit",
  connection_string: "esdb://localhost:2113?tls=false",
  pool_size: 10
config :project, Project.Repo,
  database: "giginc",
  username: "deeznutz",
  password: "0000",
  hostname: "localhost",
  port: 5433
config :project, Project.CommandedApp,
  event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: Project.Eventstore
  ],
  pubsub: :local,
  registry: :local
config :project, :globalsettings,
    defaulttransactionlimit: 10000
