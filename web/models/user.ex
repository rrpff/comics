require IEx

defmodule Comics.User do
  use Comics.Web, :model

  alias Comics.Repo
  alias Comics.User
  import Comeonin.Bcrypt

  schema "users" do
    field :username, :string
    field :api_token, :string
    field :hashed_password, :string
    field :password, :string, virtual: true

    timestamps
  end

  @required_fields ~w(username password)
  @optional_fields ~w()

  def valid_password?(user, password) do
    if user = Repo.get_by(User, username: user.username) do
      checkpw(password, user.hashed_password)
    else
      dummy_checkpw
    end
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> generate_api_token
    |> hash_password
  end

  def generate_api_token(changeset) do
    if changeset.model.api_token == nil do
      token = :crypto.strong_rand_bytes(16) |> Base.encode16(case: :lower)
      put_change(changeset, :api_token, token)
    else
      changeset
    end
  end

  def hash_password(changeset) do
    if Map.has_key?(changeset.changes, :password) do
      put_change(changeset, :hashed_password, hashpwsalt(changeset.changes.password))
    else
      changeset
    end
  end
end
