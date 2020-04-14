defmodule CookpodWeb.SessionControllerTest do
  use CookpodWeb.ConnCase
  import Plug.Test

  # SHOW
  test "GET /sessions when not authorized", %{conn: conn} do
    conn = conn
      |> init_test_session(%{current_user: "test"})
      |> get(Routes.session_path(conn, :show))
    assert text_response(conn, 401) =~ "401 Unauthorized"
  end

  test "GET /sessions when no session", %{conn: conn} do
    conn = conn
      |> put_req_header("authorization", "Basic " <> Base.encode64("admin:some_pass"))
      |> get(Routes.session_path(conn, :show))
    assert assert redirected_to(conn, 302) =~ "/sessions/new"
  end

  test "GET /sessions when authorized", %{conn: conn} do
    conn = conn
      |> init_test_session(%{current_user: "test"})
      |> put_req_header("authorization", "Basic " <> Base.encode64("admin:some_pass"))
      |> get(Routes.session_path(conn, :show))
    assert html_response(conn, 200) =~ "You are logged in"
  end

  # NEW
  test "GET /sessions/new when not authorixation", %{conn: conn} do
    conn = conn
      |> get(Routes.session_path(conn, :new))
    assert text_response(conn, 401) =~ "401 Unauthorized"
  end

  test "GET /sessions/new when authorized", %{conn: conn} do
    conn = conn
      |> put_req_header("authorization", "Basic " <> Base.encode64("admin:some_pass"))
      |> get(Routes.session_path(conn, :new))
    assert html_response(conn, 200) =~ "name"
    assert html_response(conn, 200) =~ "password"
  end

  # CREATE
  test "POST /sessions when not authorixation", %{conn: conn} do
    conn = conn
      |> post(Routes.session_path(conn, :create))
    assert text_response(conn, 401) =~ "401 Unauthorized"
  end

  test "POST /sessions when authorized", %{conn: conn} do
    conn = conn
      |> put_req_header("authorization", "Basic " <> Base.encode64("admin:some_pass"))
      |> post(Routes.session_path(conn, :create), [user: [name: "jhon", password: "doe"]])
    assert redirected_to(conn, 302) =~ "/"
  end

  # DELETE
  test "DELETE /sessions when not authorixation", %{conn: conn} do
    conn = conn
      |> delete(Routes.session_path(conn, :delete))
    assert text_response(conn, 401) =~ "401 Unauthorized"
  end

  test "DELETE /sessions when no session", %{conn: conn} do
    conn = conn
      |> put_req_header("authorization", "Basic " <> Base.encode64("admin:some_pass"))
      |> delete(Routes.session_path(conn, :delete))
    assert redirected_to(conn, 302) =~ "/sessions/new"
  end

  test "DELETE /sessions when session present", %{conn: conn} do
    conn = conn
      |> init_test_session(%{current_user: "test"})
      |> put_req_header("authorization", "Basic " <> Base.encode64("admin:some_pass"))
      |> delete(Routes.session_path(conn, :delete))
    assert redirected_to(conn, 302) =~ "/"
  end
end
