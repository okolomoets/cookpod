defmodule Cookpod.User do
  @moduledoc false
  
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmtion, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email])
    |> validate_change(:email, &check_email/2)
    |> validate_confirmation(:password, message: "Passwords does not match")
    |> encrypt_password()
    |> unique_constraint(:email)
  end

  def new_changeset() do
    changeset(%Cookpod.User{}, %{})
  end

  defp check_email(:email, email) do 
    mx_servers = fetch_mx_servers(email)
    
    if Enum.empty?(mx_servers) do 
      [email: "not valid"]
    else
      []
    end
  end

  def encrypt_password(changeset) do
    case Map.fetch(changeset.changes, :password) do
      {:ok, password} -> 
        put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))
      :error -> 
        changeset
    end
  end

  defp fetch_mx_servers(email) do 
    email
    |> String.split("@", trim: true)
    |> List.last()
    |> to_charlist
    |> :inet_res.lookup(:in, :mx)
  end
end