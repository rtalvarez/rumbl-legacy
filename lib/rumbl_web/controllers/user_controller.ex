defmodule RumblWeb.UserController do
  use RumblWeb, :controller
  plug :authenticate when action in [:index, :show]

  alias Rumbl.Users
  alias Rumbl.Users.User

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def new(conn, params) do
#    changeset = User.changeset(%User{}, params)
    changeset = Users.change_user(%User{}, params) # TODO: Missing Params?
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
#    changeset = User.registration_changeset(%User{}, user_params)
    changeset = Users.create_user(user_params)

    case changeset do
      {:ok, user} ->
        conn
        |> Rumbl.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end

end
