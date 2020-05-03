defmodule CookpodWeb.SessionControllerTest do
  use CookpodWeb.ConnCase
  import Plug.Test

  alias Cookpod.User
  alias Cookpod.Repo

  defp log_user_in(%{conn: conn}) do
    user = %Cookpod.User{email: "test@gmail.com"}
    conn = conn
       |> init_test_session(%{current_user: user})
 
    {:ok, conn: conn}
  end

  defp base_auth(%{conn: conn}) do
    conn = conn
       |> put_req_header("authorization", "Basic " <> Base.encode64("admin:some_pass"))
 
    {:ok, conn: conn}
  end

  # SHOW
  describe "authorized user withot base auth" do  
    setup [:log_user_in]

    test "GET /sessions when not authorized", %{conn: conn} do
      conn = conn
        |> get(Routes.session_path(conn, :show))
      assert text_response(conn, 401) =~ "401 Unauthorized"
    end
  end

  describe "not authorized user with base auth" do  
    setup [:base_auth]

    test "GET /sessions when no session", %{conn: conn} do
      conn = conn
        |> get(Routes.session_path(conn, :show))

      assert assert redirected_to(conn, 302) =~ "/sessions/new"
    end
  end

  describe "fully authorized" do  
    setup [:base_auth, :log_user_in]

    test "GET /sessions ", %{conn: conn} do
      conn = conn
        |> get(Routes.session_path(conn, :show))

      assert html_response(conn, 200) =~ "You are logged in"
    end
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
    User.changeset(%User{}, %{email: "test@gmail.com", password: "doe", password_confirmtion: "doe"}) 
    |> Repo.insert()
  
    conn = conn
      |> put_req_header("authorization", "Basic " <> Base.encode64("admin:some_pass"))
      |> post(Routes.session_path(conn, :create), [user: [email: "test@gmail.com", password: "doe", password_confirmtion: "doe"]])
    assert text_response(conn, 200) =~ "Correct pass"
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
    user = %Cookpod.User{email: "test@gmail.com"}
    conn = conn
      |> init_test_session(%{current_user: user})
      |> put_req_header("authorization", "Basic " <> Base.encode64("admin:some_pass"))
      |> delete(Routes.session_path(conn, :delete))
    assert redirected_to(conn, 302) =~ "/"
  end
end
