defmodule Comics.UserTest do
  use Comics.ModelCase

  alias Comics.Repo
  alias Comics.User

  @valid_attrs %{username: "tester", password: "test123"}
  @invalid_attrs %{}

  setup do
    user = Repo.insert!(User.changeset(%User{}, @valid_attrs))
    {:ok, user: user}
  end

  test "hashes passwords correctly", %{user: user} do
    first = user.hashed_password
    assert first != ""

    user = Repo.update!(User.changeset(user, %{password: "test124"}))
    second = user.hashed_password
    assert second != first

    user = Repo.update!(User.changeset(user, %{username: "test"}))
    assert user.hashed_password == second
  end

  test "checking password validity with a valid password", %{user: user} do
    assert User.valid_password?(user, "test123") == true
  end

  test "checking password validity with an invalid password", %{user: user} do
    assert User.valid_password?(user, "hackers!") == false
  end
end
