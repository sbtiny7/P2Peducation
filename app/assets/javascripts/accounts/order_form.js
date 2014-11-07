/**
 * Created by spf on 10/31/14.
 */
$(function () {

  $('.result-container .submit-order-button').on('click', function (event) {
    console.log()
    $.ajax({
      url: '/accounts/orders',
      type: 'post',
      data: {
        __token__: $("#__token__").val(),
        order: {
          trade_no: $("#order_trade_no").val(),
          goods_id: $("#order_goods_id").val(),
          quantity: $("#order_quantity").val()
        }
      },
      beforeSend: function () {
        return $.preventMultipleAjax(event);
      },
      success: function (result, status) {
        if (status == "success" && result.success) {
          location = result.redirect;
        } else {
          alert(result.message)
        }
      }
    })
  });

  $('.result').html("￥" + Number($('.o-price').html() * $('#order_quantity').val()).toFixed(2));

  $("#order_quantity").blur(function () {
    // == 0 ? 1 : Number($(this).val())
    var quantity = Number($(this).val()) , price = Number($(".o-price").html());
    $(".result").html("￥" + (price * quantity).toFixed(2));
  });

//  $('#order_quantity').on('keyup change', function (event) {
//     check_order_quantity(event);
//  });

//  function check_order_quantity(event){
//    var quantity = Number($(this).val()) , price = Number($(".o-price").html());
//    var result = null;
//    $(".result").html("￥" + (price * quantity).toFixed(2));
//    $.ajax({
//      url: '/accounts/orders/check_quantity',
//      type: 'post',
//      data: {
//        order: {
//          quantity: $("#order_quantity").val(),
//          goods_id: $("#order_goods_id").val()
//        }
//      },
//      beforeSend: function () {
//        return $.preventMultipleAjax(event);
//      },
//      success: function (res, status) {
//        result = res;
//      }
//    });
//  }
//
//  $('.submit-order-button').preventMultipleClick();
//  $("#account_order_new_form").submit(function (event) {
//    return $(this).valid();
//  });
//  $("#account_order_new_form").on('ajax:success', function (event, result) {
//    if (result.success) {
//      console.log(result)
//      location = result.redirect;
//    } else {
//      alert(result.message);
//    }
//  });
//  $("#account_order_new_form").validate({
//    rules: {
//      "order[trade_no]": {
//        required: true
//      },
//      "order[price]": {
//        required: true,
//        number: true,
//        min: 0.01
//      },
//      "order[discount]": {
//        number: true
//      },
//      "order[quantity]": {
//        required: true,
//        digits: true,
//        min: 0,
//        remote: {
//          url: '/accounts/orders/check_quantity',
//          data: {
//            goods_id: function () {
//              return $("#order_goods_id").val();
//            }
//          },
//          type: 'post'
//        }
//      }
//    },
//    messages: {
//      "order[trade_no]": {
//        required: "交易号不能为空"
//      },
//      "order[price]": {
//        required: "请输入产品价格",
//        number: "请输入有效数字",
//        min: '请输入有效数字'
//      },
//      "order[discount]": {
//        number: "请输入有效数字"
//      },
//      "order[quantity]": {
//        required: "请输入产品数量",
//        digits: "请输入有效整数",
//        min: "产品数量不能为负数",
//        remote: "抱歉，没有那么多的空位啦！"
//      }
//    },
//    success: function (erorr, ele) {
//
//    },
//    errorPlacement: function (error, ele) {
//      console.log(error)
//    }
//  })
});