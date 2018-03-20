defmodule RumblWeb.Router do
  use RumblWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Rumbl.Auth, repo: Rumbl.Repo)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    #    plug Corsica, origin: "https://localhost:8082"
  end

  scope "/", RumblWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/watch/:id", WatchController, :show)

    resources("/users", UserController, only: ~w(index show new create)a)
    resources("/sessions", SessionController, only: ~w(new create delete)a)
  end

  scope "/proxy", RumblWeb do
    pipe_through(:api)

    get("/*path", PageController, :proxy)
    #    options "/*path", PageController, :options_proxy
  end

  scope "/manage", RumblWeb do
    pipe_through([:browser, :authenticate_user])

    resources("/videos", VideoController)
  end

  # Other scopes may use custom stacks.
  # scope "/api", RumblWeb do
  #   pipe_through :api
  # end
end
