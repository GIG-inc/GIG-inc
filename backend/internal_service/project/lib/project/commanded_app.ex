defmodule Project.CommandedApp do
  use Commanded.Application,
    otp_app: :Project,
  # this allows for reading of documentation from the config.exs
    router: [
     Routers.Accountopenrouter.Accountrouter,
     Routers.Transferrouter,
     Routers.Salerouter,
     Routers.Capitalraise,
     Routers.Depositrouter,
     Routers.Marketopeningrouter
    ]
end
