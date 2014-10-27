//= require 'china_city/jquery.china_city'

$(function(){

    $('.upload_image:not(input)').mouseover(function(){
        $('icon.upload_image').show();
    }).mouseout(function(){
        $('icon.upload_image').hide();
    })

    $('input.upload_image').change(function(){
        on_upload_image($(this));
    })

    $('input.datetime').datepicker({ constrainInput: false })
})

function on_upload_image(sender) {
    if( !sender.val().match( /.jpg|.jpeg|.gif|.png/i ) ){
        alert('图片格式无效！');
        return false;
    }
    var img = sender.parent().children('img')[0];
    var ie_preview_wrapper = sender.parent().children('.ie_preview_wrapper');
    var ie_preview = ie_preview_wrapper.children('.ie_preview');
    if( sender[0].files &&  sender[0].files[0] ){
        img.src = window.URL.createObjectURL(sender[0].files[0]);
    } else if( ie_preview[0].filters ) {
        sender.parent().children('img').hide();
        sender.select();
        sender.blur();
        var path = document.selection.createRange().text;
        ie_preview[0].filters.item('DXImageTransform.Microsoft.AlphaImageLoader').src = path;
    }
}