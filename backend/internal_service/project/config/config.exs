import Config
config :project, ecto_repos: [Project.Repo]

config :project, Project.Repo,
  database: "giginc",
  username: "deeznutz",
  password: "0000",
  hostname: "localhost",
  port: 5433
