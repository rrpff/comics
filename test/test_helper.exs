ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Comics.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Comics.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Comics.Repo)

