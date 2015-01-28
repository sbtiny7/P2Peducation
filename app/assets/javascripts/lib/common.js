//！！！全局作用域！！！

(function ($) {
  /**
   * 防止重复提交。
   * 使用：
   *   在jquery的ajax方法中加入参数:beforeSend
   *   例如：
   *     beforeSend: function(){return $.preventMultipleAjax(event, 3000)}
   *     beforeSend: function(){return $.preventMultipleAjax(event, 5000)}
   *
   * @param event
   * @param delay_duration
   * @returns {boolean}
   */
  $.preventMultipleAjax = function (event, delay_duration) {
    delay_duration = delay_duration || 3000;
    var target = $(event.target);
    var last_click_time_stamp = target.attr("_ajax_send_time_stamp") || 0;
    var time_duration = last_click_time_stamp ? event.timeStamp - last_click_time_stamp : 0;
    //console.debug("preventMultipleAjax", last_click_time_stamp, time_duration);
    if (time_duration && time_duration < delay_duration) {
      return false;
    } else {
      //console.debug("skip preventMultipleAjax~");
      target.attr("_ajax_send_time_stamp", event.timeStamp);
      return true;
    }
  };

  /**
   * 防止按钮重复点击。
   * NOTICE: #1 需要在作用点之前调用此方法 #2 stopImmediatePropagation 会阻止后面的所有事件包括事件冒泡
   * @delay_duration 两次点击的间隔时间
   */
  $.fn.preventMultipleClick = function (delay_duration) {
    delay_duration = delay_duration || 3000;
    var last_click_time_stamp = 0;
    var time_duration = 0;
    $(this).bind('click', function (event) {
      time_duration = last_click_time_stamp ? event.timeStamp - last_click_time_stamp : 0;
      //console.debug("preventMultipleClick", last_click_time_stamp, time_duration);
      if (time_duration && time_duration < delay_duration) {
        event.stopImmediatePropagation();
      } else {
        //console.debug("skip preventMultipleClick~");
        last_click_time_stamp = event.timeStamp;
      }
    });
  };

})(jQuery);

function crossDomainAjax (url, successCallback) {

    // IE8 & 9 only Cross domain JSON GET request
    if ('XDomainRequest' in window && window.XDomainRequest !== null) {

        var xdr = new XDomainRequest(); // Use Microsoft XDR
        xdr.open('get', url);
        xdr.onload = function () {
            var dom  = new ActiveXObject('Microsoft.XMLDOM')
            var JSON;
            try {
                JSON = $.parseJSON(xdr.responseText);
            } catch(err) {
                JSON = null;
            }

            dom.async = false;

            if (JSON == null || typeof (JSON) == 'undefined') {
                try {
                    JSON = $.parseJSON(data.firstChild.textContent);
                } catch(err) {
                    JSON = null;
                }
            }

            if (JSON == null || typeof (JSON) == 'undefined') {
                JSON = {};
            }

            successCallback(JSON); // internal function
        };

        xdr.onerror = function() {
            _result = false;
        };

        xdr.send();
    } else {
        $.ajax({
            url: url,
            cache: false,
            dataType: 'json',
            type: 'GET',
            async: false, // must be set to false
            success: function (data, success) {
                successCallback(data);
            }
        });
    }
}


function play_video(width, height, file, image, autoplay, vstate)
{
    if (vstate == 'LIVING')
    {
        var flashvars = {
            src:file,
            streamType:"live",
            autoPlay:autoplay,
            poster:image,
            controlBarAutoHide:true,
            bufferTime:2,
            initialBufferTime:0.5,
            liveBufferTime:2
        };
    }
    else
    {
        var flashvars = {
            src:file,
            autoPlay:autoplay,
            poster:image,
            controlBarAutoHide:true,
            plugin_hls: "/HLSDynamicPlugin.swf"
        };
    }


    var params = {
//src: file,
//autoPlay: autoplay,
//controlBarAutoHide: true,
//poster: image,
//javascriptCallbackFunction: ""
        allowFullScreen:  "true",
        wmode: "transparent"
    };
    var attributes = {

    };
    swfobject.embedSWF (
        "/Strobe601.swf",
//"http://osmf.org/dev/2.0gm/StrobeMediaPlayback.swf",
        "stream-player",
        width, height, "10.1.0", "/expressInstall.swf",
        flashvars, params, attributes);
}
