$(function() {
    var checked = false;
    $("#get_captcha").click(function(){
        if ($('#order').validate().element("#phone")) {
            init_status();
            var phone = $("#phone").val();
            $.post('/api/server/send_captcha', {phone: phone}, function(data) {
            });
            stopwatch();
        }
    });

    function stopwatch() {
        var timer = 60;
        setInterval(function() {
            if (timer < 0) {
                reset_status();
                timer = 60
            } else {
                $("#re_get").html(timer + "秒后重新获取")
                timer--;
            }
        }, 1000)
    }
    function init_status() {
        $('#phone').attr('readonly', 'readonly');
        $('#get_captcha').attr('disabled', 'disabled');
        $('#re_get').show();
    }
    function reset_status() {
        $('#get_captcha').removeAttr('disabled');
        $('#re_get').hide().html('正在获取验证码...');
        $('#phone').removeAttr('readonly');
    }

    $("#order").validate({
            errorPlacement: function(error, element) {
                element.closest("div").find('.error_message').html(error);
            },
            rules: {
                "phone": "required",
                "captcha": "required",
                "agree": "required",
                "username": "required"
            },
            messages: {
                "agree": "必须同意服务协议"
            }
        }
    )
    $("#confirm").click(function() {
        var captcha = $("#captcha").val();
        $.post('/api/server/check_captcha', {captcha: captcha}, function(data) {
            if (data.result = "ok") {
                checked = true;
            }
        })
    })
    $('#order').submit(function() {
        if ($("[name='courses[]']:checked").length == 0) {
            alert("请至少选择一件商品")
            return false;
        }
    })
})
