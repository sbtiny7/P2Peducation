/**
 * Created by spf on 10/31/14.
 */
$(function () {
  $('.submit-order-button').preventMultipleClick();
  console.log("aaaaaaaaaaaaaaaaaaaaaaaaaa")
  $("#account_order_new_form").validate({
    rules: {
      "order[trade_no]": {
        required: true
      },
      "order[price]": {
        required: true,
        number: true
      },
      "order[discount]": {
        number: true
      },
      "order[quantity]": {
        required: true,
        digits: true,
        min: 0
      }
    },
    messages: {
      "order[trade_no]": {
        required: "交易号不能为空"
      },
      "order[price]": {
        required: "请输入产品价格",
        number: "请输入有效数字"
      },
      "order[discount]": {
        number: "请输入有效数字"
      },
      "order[quantity]": {
        required: "请输入产品数量",
        digits: "请输入有效整数",
        min: "产品数量不能为负数"
      }
    },
    success: function (erorr, ele) {

    },
    errorPlacement: function (error, ele) {
        console.log(error)
    }
  })
});