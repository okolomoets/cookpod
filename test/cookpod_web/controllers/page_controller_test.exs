defmodule CookpodWeb.PageControllerTest do
  use CookpodWeb.ConnCase
  import Plug.Test

  test "GET /", %{conn: conn} do
    conn = conn
      |> init_test_session(%{current_user: "test"})
      |> put_req_header("authorization", "Basic " <> Base.encode64("admin:some_pass"))
      |> get("/")
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
