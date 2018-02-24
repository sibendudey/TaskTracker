defmodule Tasktracker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Accounts.User
  alias Tasktracker.Account.Manage

  schema "users" do
    field :email, :string
    field :name, :string
    has_one :manager_manages, Manage, foreign_key: :manager_id
    has_many :managee_manages, Manage, foreign_key: :managee_id
    has_one :manager, through: [:manager_manages, :manager]
    has_many :managees, through: [:managee_manages, :managee]
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end
end
