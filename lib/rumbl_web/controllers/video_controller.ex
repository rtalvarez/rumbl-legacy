defmodule RumblWeb.VideoController do
  use RumblWeb, :controller

  alias Rumbl.Videos

  plug(:load_categories when action in [:new, :create, :edit, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, user) do
    videos = Videos.get_user_videos(user)
    render(conn, "index.html", videos: videos)
  end

  def new(conn, _params, user) do
    changeset =
      user
      |> build_assoc(:videos)
      |> Videos.change_video()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"video" => video_params}, user) do
    changeset = Videos.create_video(user, video_params)

    case changeset do
      {:ok, _video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: video_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    video = Videos.get_user_video!(user, id, %{:preload => :category})

    render(conn, "show.html", video: video)
  end

  def edit(conn, %{"id" => id}, user) do
    video = Videos.get_user_video!(user, id)
    changeset = Videos.change_video(video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}, user) do
    video = Videos.get_user_video!(user, id)

    case Videos.update_video(video, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: video_path(conn, :show, video))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => video_id}, user) do
    result = Videos.delete_user_video(user, video_id)

    case result do
      {:ok, _video} ->
        conn
        |> put_flash(:info, "Video deleted successfully.")
        |> redirect(to: video_path(conn, :index))

      #        TODO: Does this work?
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Video could not be deleted.")
    end
  end

  defp load_categories(conn, _) do
    categories = Videos.load_categories()
    assign(conn, :categories, categories)
  end
end
