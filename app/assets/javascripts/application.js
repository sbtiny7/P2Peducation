//= require jquery
//= require jquery_ujs
//= require lib/common
//= require bootstrap-sprockets
//= require share
//= require plugins/validate/index

//jQuery.validator.addMethod("notEqual", function(value, element, param) {
//  return this.optional(element) || value ! param;
//}, "Please specify a different (non-default) value");
//jQuery.validator.addMethod("isPhone", function(value, element) {
//    var length = value.length;
//    var mobile = /^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1}))+\d{8})$/;
//    var tele = /^\d{3,4}-?\d{7,9}$/
//    return this.optional(element) || (length == 11 && mobile.test(value)) || tele.test(value);
//}, "请填写正确的电话号码（固话含区号）");
