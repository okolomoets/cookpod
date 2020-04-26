# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Cookpod.Repo.insert!(%Cookpod.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Cookpod.User
alias Cookpod.Repo

admin = User.changeset(%User{}, %{email: "admin@gmail.com", password: "admin_pass"})
user = User.changeset(%User{}, %{email: "user@gmail.com", password: "user_pass"})
Repo.insert!(admin)
Repo.insert!(user)
