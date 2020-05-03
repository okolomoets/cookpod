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
    plug BasicAuth, use_config: {:cookpod, :basic_auth}
  end

  scope "/", CookpodWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/terms", PageController, :terms
    resources "/sessions", SessionController, singleton: true, except: [:new, :create]
    resources "/recipes", RecipeController 
  end

  scope "/", CookpodWeb do
    pipe_through :browser
    
    get "/sign_up", UserController, :new
    resources "/users", UserController, only: [:create]
    resources "/sessions", SessionController, singleton: true, only: [:new, :create]
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", CookpodWeb.Api, as: :api do
    pipe_through [:api]
    
    resources "/recipes", RecipeController 
  end

  scope "/api/v1/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :cookpod, swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Cookpod"
      },
      basePath: "/api/v1"
    }
  end
end
