defmodule Cookpod.Recipes.Recipe do
  @moduledoc false
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  schema "recipes" do
    field :description, :string
    field :name, :string
    field :picture, Cookpod.Picture.Type

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast_attachments(attrs, [:picture])
    |> cast(attrs, [:name, :description, :picture])
    |> validate_required([:name, :description, :picture])
    |> unique_constraint(:name)
  end
end
