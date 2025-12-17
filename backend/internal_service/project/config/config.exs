import Config
config :project, ecto_repos: [Project.Repo]
config :project,  Comms.Endpoint,
  port: 50053,
  adapter: GRPC.Adapter.Cowboy,
  ip: {0, 0, 0, 0},
  cowboy_opts: []
config :project, Project.Application,
  event_store_adapter: Commanded.EventStore.Adapters.EventStoreDB
config :eventstore, Project.Eventstore,
  serializer: EventStore.JsonSerializer,
  database: "eventstore",
  username: "deeznutz",
  password: "0000",
  hostname: "localhost",
  pool_size: 10,
  port: 5433
config :project, Project.Repo,
  database: "giginc",
  username: "deeznutz",
  password: "0000",
  hostname: "localhost",
  pool_size: 10,
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
config :logger, level: :debug
