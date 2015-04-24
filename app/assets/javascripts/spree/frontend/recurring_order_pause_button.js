$(document).ready(function(){
  $(".activate-recurring-order form, .pause-recurring-order form").on("ajax:success", function(e) {
    location.reload(false)
  });
});