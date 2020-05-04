defmodule CookpodWeb.Api.RecipeControllerTest do
  use CookpodWeb.ConnCase
  import Plug.Test

  alias Cookpod.Recipes

  @create_attrs %{
    description: "test description", 
    name: "test name", 
    picture: %Plug.Upload{
      path: 'test/fixtures/images/test.png',
      content_type: "image/png",
      filename: "test.png"
    }
  }

  setup :base_auth

  def base_auth(%{conn: conn}) do
    conn = conn
       |> put_req_header("authorization", "Basic " <> Base.encode64("admin:some_pass"))
 
    {:ok, conn: conn}
  end

  describe "index" do
    test "GET /api/v1/recipes", %{conn: conn} do
      {:ok, record} = Recipes.create_recipe(@create_attrs)
      conn = get(conn, Routes.api_recipe_path(conn, :index))
      %{"data" => [recipe]} = json_response(conn, 200)
      
      assert recipe["id"] == record.id
      assert recipe["name"] == "test name"
      assert recipe["description"] == "test description"
    end
  end

  describe "show" do
    test "GET /api/v1/recipes/:id", %{conn: conn} do
      {:ok, record} = Recipes.create_recipe(@create_attrs)
      conn = get(conn, Routes.api_recipe_path(conn, :show, record))
      %{"data" => recipe} = json_response(conn, 200)
      
      assert recipe["id"] == record.id
      assert recipe["name"] == "test name"
      assert recipe["description"] == "test description"
    end
  end
end
