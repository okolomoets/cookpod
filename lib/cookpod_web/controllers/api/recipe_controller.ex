defmodule CookpodWeb.Api.RecipeController do
  use CookpodWeb, :controller
  use PhoenixSwagger

  alias Cookpod.Recipes

  def swagger_definitions do
    %{
      Recipe:
        swagger_schema do
          title("Recipe")
          description("Endpoint to fetch recipes data.")

          properties do
            id(:integer, "Recipe ID", required: true)
            name(:string, "Recipe name", required: true)
            description(:string, "Recipe description", required: true)
          end

          example(%{
            id: 123,
            name: "Eggs",
            description: "Some description"
          })
        end
    }
  end

  swagger_path :index do
    get "/recipes"
    description "List recipes"
    response 200, "Success", Schema.array(:Recipe)
  end
  def index(conn, _params) do
    recipes = Recipes.list_recipes()
    render(conn, "index.json", recipes: recipes)
  end

  swagger_path :show do
    get "/recipes/{id}"
    description "Recipe data"
    parameter :id, :path, :integer, "Recipe ID", required: true, example: 1
    response 200, "Success", Schema.ref(:Recipe)
  end
  def show(conn, %{"id" => id}) do
    recipe = Recipes.get_recipe!(id)
    
    render(conn, "show.json", recipe: recipe)
  end
end
