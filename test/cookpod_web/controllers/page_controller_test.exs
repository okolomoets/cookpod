defmodule CookpodWeb.PageControllerTest do
  use CookpodWeb.ConnCase
  import Plug.Test
  alias Cookpod.User

  test "GET /", %{conn: conn} do
    user = %User{email: "test@gmail.com"}
    conn = conn
    |> init_test_session(%{current_user: user})
    |> put_req_header("authorization", "Basic " <> Base.encode64("admin:some_pass"))
    |> get(Routes.page_path(conn, :index))

    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
