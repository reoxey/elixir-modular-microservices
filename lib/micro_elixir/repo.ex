defmodule MicroElixir.Repo do
  use Ecto.Repo,
    otp_app: :micro_elixir,
    adapter: Ecto.Adapters.SQLite3
end
