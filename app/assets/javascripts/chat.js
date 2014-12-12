//user_id, faye_server, chat_channel get from server
var client = new Faye.Client(gon.faye_server);
client.subscribe(gon.chat_channel, handle_message)

function handle_message(data) {
    if(data.user_id == gon.user_id) return;
    print_message(data)
}

function print_message(data) {
    $("#chat_box").append("<div>" + data.user_id + ": " + data.content + "</div>")
}

$("#send_message").click(function() {
    var content = $("#message").val();
    var message = {content: content, user_id: gon.user_id, comment_token: gon.comment_token};
    print_message(message)
    $.post("/chat_server/send_message",
           {channel: gon.chat_channel, message: message});
})
