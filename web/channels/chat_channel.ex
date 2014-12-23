defmodule ElixirChat.ChatChannel do
  use Phoenix.Channel
  alias ElixirChat.ChatLogServer, as: Chats

  def join(socket, chat_id, %{"userId" => id, "role" => "teacher"}) do
    socket = assign(socket, :teacher_id, id)
    socket = assign(socket, :chat_id, chat_id)

    {:ok, socket}
  end

  def join(socket, chat_id, %{"userId" => id, "role" => "student"}) do
    socket = assign(socket, :student_id, id)
    socket = assign(socket, :chat_id, chat_id)

    {:ok, socket}
  end

  def event(socket, "teacher:joined", message) do
    id      = socket.assigns[:teacher_id]
    chat_id = socket.assigns[:chat_id]

    chat = Chats.teacher_entered(chat_id, id)

    if chat.teacher_entered && chat.student_entered do
      broadcast socket, "chat:ready", %{}
    end

    socket
  end

  def event(socket, "student:joined", message) do
    id      = socket.assigns[:student_id]
    chat_id = socket.assigns[:chat_id]

    chat = Chats.student_entered(chat_id, id)

    if chat.teacher_entered && chat.student_entered do
      broadcast socket, "chat:ready", %{}
    end

    socket
  end
end