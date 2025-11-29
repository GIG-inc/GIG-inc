import Config
config :Project, ecto_repos: [Project.Repo]
# config :grpc, start_server: true
# config :project,  Comms.Endpoint,
#   port: 50052,
#   adapter: GRPC.Adapter.Cowboy,
#   cowboy_opts: []
config :Project, Project.Application,
  event_store_adapter: Commanded.EventStore.Adapters.EventStoreDB
config :eventstore, Project.Eventstore,
  serializer: EventStore.JsonSerializer,
  database: "eventstore",
  username: "deeznutz",
  password: "0000",
  hostname: "localhost",
  pool_size: 10,
  port: 5433
config :Project, Project.Repo,
  database: "giginc",
  username: "deeznutz",
  password: "0000",
  hostname: "localhost",
  pool_size: 10,
  port: 5433
config :Project, Project.CommandedApp,
  event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: Project.Eventstore
  ],
  pubsub: :local,
  registry: :local
config :Project, :globalsettings,
    defaulttransactionlimit: 10000
