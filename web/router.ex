defmodule Comics.Router do
  use Comics.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Comics do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", Comics do
    pipe_through :api
  end
end
