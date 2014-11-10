$(function() {
    $("#course_category_list a").click(function(e) {
        console.log(this);
        e.preventDefault();
        $(this).tab("show");
        console.log("click");
    });
});
