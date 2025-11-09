import Config
config :project, ecto_repos: [Project.Repo]
# config :grpc, start_server: true
# config :project,  Comms.Endpoint,
#   port: 50052,
#   adapter: GRPC.Adapter.Cowboy,
#   cowboy_opts: []
config :project, Project.Repo,
  database: "giginc",
  username: "deeznutz",
  password: "0000",
  hostname: "localhost",
  port: 5433
