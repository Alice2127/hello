defmodule HelloWeb.UserController do
  use HelloWeb, :controller

  def index(conn, _params) do
    # redirect(conn, to: ~p"/") #内部のリダイレクトは~pを使う
    # redirect(conn, external: "https://elixir-lang.org/")
    user_id = 42
    post_id = 17
    redirect(conn, to: ~p"/users/#{user_id}/#{post_id}") #クエリ文を使ったリダイレクト※コントローラを作っていないのでエラーになるがルーティングは取れている
  end
end
