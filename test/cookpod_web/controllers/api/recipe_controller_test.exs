defmodule CookpodWeb.Api.RecipeControllerTest do
  use CookpodWeb.ConnCase
  use PhoenixSwagger.SchemaTest, "priv/static/swagger.json"

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

  setup [:base_auth, :create_recipe]

  def base_auth(%{conn: conn}) do
    conn = conn
       |> put_req_header("authorization", "Basic " <> Base.encode64("admin:some_pass"))
 
    {:ok, conn: conn}
  end

  def create_recipe(_) do
    {:ok, recipe} = Recipes.create_recipe(@create_attrs)
    {:ok, %{recipe: recipe}}
  end


  describe "index" do
    test "expected response data", %{conn: conn, recipe: record} do
      conn = get(conn, Routes.api_recipe_path(conn, :index))
      %{"data" => [recipe]} = json_response(conn, 200)
      
      assert recipe["id"] == record.id
      assert recipe["name"] == "test name"
      assert recipe["description"] == "test description"
    end

    test "schema validation", %{conn: conn, swagger_schema: schema, recipe: record} do
      conn 
      |> get(Routes.api_recipe_path(conn, :index))
      |> validate_resp_schema(schema, "Recipe")
      |> json_response(200)
    end
  end

  describe "show" do
    test "GET /api/v1/recipes/:id", %{conn: conn, recipe: record} do
      conn = get(conn, Routes.api_recipe_path(conn, :show, record))
      %{"data" => recipe} = json_response(conn, 200)
      
      assert recipe["id"] == record.id
      assert recipe["name"] == "test name"
      assert recipe["description"] == "test description"
    end

    test "schema validation", %{conn: conn, swagger_schema: schema, recipe: record} do    
      conn 
      |> get(Routes.api_recipe_path(conn, :show, record))
      |> validate_resp_schema(schema, "Recipe")
      |> json_response(200)
    end
  end
end
