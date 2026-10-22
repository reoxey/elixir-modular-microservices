defmodule MicroElixirWeb.PageController do
  use MicroElixirWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
