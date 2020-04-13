defmodule CookpodWeb.Router do
  use CookpodWeb, :router
  use Plug.ErrorHandler

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BasicAuth, use_config: {:cookpod, :basic_auth}
  end

  pipeline :auth do
    plug CookpodWeb.AuthPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CookpodWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/terms", PageController, :terms
    resources "/sessions", SessionController, singleton: true, except: [:new, :create]
  end

  scope "/", CookpodWeb do
    pipe_through :browser

    resources "/sessions", SessionController, singleton: true, only: [:new, :create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", CookpodWeb do
  #   pipe_through :api
  # end

  def handle_errors(conn, %{kind: :error, reason: %Phoenix.Router.NoRouteError{}}) do
    conn
    |> put_view(CookpodWeb.ErrorView)
    |> render("404.html")
  end

  def handle_errors(conn, _), do: conn
end
