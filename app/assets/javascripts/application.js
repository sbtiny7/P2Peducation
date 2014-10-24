// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require json2
//= require kindeditor
//= require make_ie_happy
//= require jquery.ui.all
//= require jquery.ui.datepicker
//= require jquery-ui-timepicker-addon
//= require jquery.ui.datepicker-zh-CN.js.js
//= require jquery-ui-timepicker-zh-CN.js
//= require jquery.ui.timepicker
//= require jquery.placeholder.js
//= require jquery.validate
//= require additional-methods.min.js
//= require jquery.jcrop
//= require bootstrap-sprockets
//= require_tree .
$(function(){
  $('input, textarea').placeholder();
})
