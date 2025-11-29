defmodule Project.Repo do
  use Ecto.Repo,
    otp_app: :Project,
    adapter: Ecto.Adapters.Postgres
end
