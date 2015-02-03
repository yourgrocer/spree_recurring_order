function SpreeRegularQuickCart() {

  var that = this;

  this.initializeQuickCartForm = function() {
    var baseListId = $.cookie("base_list_id");
    that.order_path = '/shop/api/recurring_lists/' + baseListId;

    $(".regular-quick-add-to-cart-form").find("form").submit(function() {
      var submitButton = $(this).find("button");
      that.buttonEnabled(submitButton, false);

      Spree.ajax({
        url: that.order_path,
        type: "PUT",
        data: $(this).serialize(),

        success: function() {
          that.showFlashMessage('Item was added to your regular list. Go to My Account to see all your regular items', true);
        },
        error: function() {
          that.showFlashMessage('There was a problem adding the item to your list. Please reload the page and try again.', false);
        },
        complete: function() {
          that.buttonEnabled(submitButton, true);
        }
      });
      return false;
    });
  };

  this.showFlashMessage = function(message, success) {
    var messageClass;
    if (success == true){ messageClass = 'success'} else { messageClass = 'error' };
    $('#default').prepend("<div class='quick-cart-flash " + messageClass + "'>" + message + "</div>");
    timeoutID = window.setTimeout(function(){
      $('#default').find(".quick-cart-flash").remove();
    }, 3000);
  };

  this.buttonEnabled = function(button, enabled) {
    if (enabled == false){
      button.attr("disabled", "disabled");
      button.text("Adding..");
    } else {
      button.removeAttr("disabled");
      button.text("Add Regular");
    }
  };

}

$(document).ready(function() {
  var quickCart = new SpreeRegularQuickCart();
  quickCart.initializeQuickCartForm();
});
