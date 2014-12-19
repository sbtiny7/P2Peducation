//user_id, faye_server, chat_channel get from server
var client = new Faye.Client(gon.faye_server);
client.subscribe(gon.chat_channel, handle_message);
client.subscribe(gon.video_channel, video_handle);

function video_handle(data) {
    switch(data.cmd) {
        case "video_start":
            //TODO get url from media server
            video_url = "rtmp://" + gon.media_server + "/" + data.app_name +
            "/" + data.token ;
            play_video(700, 525, video_url, "", true, "LIVING");
            break;
        case "video_stop":
            $('.live_video').html('<div id="stream-player"></div>');
            $("#stream-player").css('visibility','visible')
            break;
    }
    console.log(data);
}

function handle_message(data) {
    if(data.user_id == gon.user_id) return;
    print_message(data)
}

function print_message(data) {
    $('#comment_template').tmpl(data).appendTo(".comments_pane").hide().fadeIn(1000);
    var scroll_top = $('.comments_pane')[0].scrollHeight - $('.comments_pane').height();
    $('.comments_pane').animate({scrollTop:scroll_top+"px"}, 1000, function(){});
}

var send_message = function() {
    var content = $("#comment").val();
    var message = {content: content, user_id: gon.user_id,
        comment_token: gon.comment_token, username: gon.username};
    print_message(message)
    $.post("http://" + gon.chat_server + "/chat_server/send_message",
           {channel: gon.chat_channel, message: message});

    $("#comment").val("");
};

$("#send_message").click(send_message());

$('#comment').keypress(function (e) {
    if (e.which == 13) {
        send_message();
    }
});



var last_comment_id = 0;
var load_more = true;
function load_comments() {
    if (load_more) {
        var href = "http://" + gon.chat_server + '/chat_server/messages/' +
            gon.comment_token + '/' + last_comment_id;
        crossDomainAjax(href, function(result){
            if (result.length > 0) {
                last_comment_id = result[result.length - 1].id;
                $.each(result.reverse(), function(i, field){
                    $('#comment_template').tmpl(field).appendTo(".comments_pane").hide().fadeIn(1000);
                });
            } else {
                load_more = false;
            }
            //$('#comment_list').animate({scrollTop:$('#comment_list')[0].scrollHeight+"px"}, 0);
        });
    }
}

load_comments();


var scroll_top = $('.comments_pane')[0].scrollHeight - $('.comments_pane').height();
$('.comments_pane').animate({scrollTop:scroll_top+"px"}, 1000, function(){});

if (gon.live) {
    video_url = "rtmp://" + gon.media_server + "/" + gon.app_name +
    "/" + gon.token ;
    play_video(600, 400, video_url, "", true, "LIVING");
}
