defmodule HelloWeb.Router do
  use HelloWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {HelloWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug HelloWeb.Plugs.Locale, "en"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/admin", HelloWeb do #認証を通じて認可の範囲を分けたい場合（管理者）
    pipe_through :browser

    get "/hello", HelloController, :index
  end

  scope "/", HelloWeb do #認証を通じて認可の範囲を分けたい場合（非管理者）
    pipe_through :browser

    get "/", PageController, :home
    get "/hello", HelloController, :index
    get "/hello/:messenger", HelloController, :show
    resources "/users", UserController do #1人のuserが複数のpostsを投稿できるルーティングにしたい場合ネストさせる
      resources "/posts", PostController #アプリケーション名が異なればscope内では同じrouteを定義しても衝突しない
    end
    resources "/reviews", ReviewController
  end

  scope "/", AnotherAppWeb do
    pipe_through :browser

    resources "/users", UserController #アプリケーション名が異なればscope内では同じrouteを定義しても衝突しない
  end

  scope "/admin", HelloWeb.Admin do
    pipe_through :browser

    resources "/reviews", ReviewController
  end

  # Other scopes may use custom stacks.
  scope "/api", HelloWeb.Api, as: :api do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      resources "/images",  ImageController
      resources "/reviews", ReviewController
      resources "/users",   UserController
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:hello, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: HelloWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
