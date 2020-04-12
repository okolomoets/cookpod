defmodule CookpodWeb.AuthPlug do
  import Plug.Conn, only: [get_session: 2, assign: 3]
  import Phoenix.Controller, only: [redirect: 2]
  alias CookpodWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :current_user) do
      nil -> redirect(conn, to: Routes.session_path(conn, :new))
      user -> assign(conn, :current_user, user)
    end
  end
end
