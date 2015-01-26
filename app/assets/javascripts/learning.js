$(function() {
    $(".category-course-image").hover(function(){
        $(this).find('.reverse').show();
        $(this).find('.mask').show();
    }, function() {
        $(this).find('.reverse').hide();
        $(this).find('.mask').hide();
    })
});