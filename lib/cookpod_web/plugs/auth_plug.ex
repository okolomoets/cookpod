defmodule CookpodWeb.AuthPlug do
  @moduledoc false
  import Plug.Conn, only: [get_session: 2, assign: 3, halt: 1]
  import Phoenix.Controller, only: [redirect: 2]
  alias CookpodWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :current_user) do
      nil ->
        conn
          |> redirect(to: Routes.session_path(conn, :new))
          |> halt()
      user -> assign(conn, :current_user, user)
    end
  end
end
