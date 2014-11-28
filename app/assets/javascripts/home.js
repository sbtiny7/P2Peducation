var home = {};
home.index = 0;
home.current_category = 1;

$(function() {
  $('.indicator li').click(function() {
    if (home.handler)  clearTimeout(home.handler);
    home.index = parseInt($(this).data("index"));
    banner_switch(home.index);
  });
  home.handler = setTimeout(next, 5000);

  $('.category-icon').tooltip();

  set_pre_next_button_visibility();
  $("#pre-button").click(function() {
    horizonal_offset(".category-slider-container", 915);
    home.current_category--;
    set_pre_next_button_visibility();
  });

  $("#next-button").click(function() {
    horizonal_offset(".category-slider-container", -915);
    home.current_category++;
    set_pre_next_button_visibility();
  })
});

function banner_switch(index) {
  // background switch
  $(".banner-bg.bg-active").removeClass("bg-active").addClass("bg-inactive");
  s = ".banner-bgs .banner-bg:nth-child(" + (index+1) + ")";
  $(s).removeClass("bg-inactive").addClass("bg-active");

  home.handler = setTimeout(next, 5000);

  // introducation switch
  s = "/assets/people-" + (index+1) + ".jpg";
  $(".banner-intro-head img").attr("src", s);

  // indicator switch
  $(".indicator-active").removeClass("indicator-active").addClass("indicator-inactive");
  var s = ".indicator li:nth-child(" + (index+1) + ")";
  $(s).removeClass("indicator-inactive").addClass("indicator-active");
}

function next() {
  home.index++;
  home.index %= 5;
  banner_switch(home.index);
}

function horizonal_offset(selector, offset) {
  var old_val = parseInt($(selector).css("left"));
  var new_val = old_val + offset;
  $(selector).css("left", new_val);
}

function set_pre_next_button_visibility() {
  if (home.current_category == 1) {
    $("#pre-button").css("visibility", "hidden");
  }
  else {
    $("#pre-button").css("visibility", "visible");
  }

  if (home.current_category == 4) {
    $("#next-button").css("visibility", "hidden");
  }
  else {
    $("#next-button").css("visibility", "visible");
  }
}
