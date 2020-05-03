defmodule CookpodWeb.Api.RecipeController do
  use CookpodWeb, :controller

  alias Cookpod.Recipes

  def index(conn, _params) do
    recipes = Recipes.list_recipes()
    render(conn, "index.json", recipes: recipes)
  end

  def show(conn, %{"id" => id}) do
    recipe = Recipes.get_recipe!(id)
    
    render(conn, "show.json", recipe: recipe)
  end
end
