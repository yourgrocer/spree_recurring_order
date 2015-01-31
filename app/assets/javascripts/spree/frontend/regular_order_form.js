function RegularOrderForm() {

  var that = this;
  this.initialize = function(){
    $("#recurring-order-form a.delete").click(function(){
      var itemId = this.attributes["id"].value.replace("delete_","");
      $.ajax({
        url: 'recurring_list_items/' + itemId,
        type: 'DELETE',
        complete: function(result){
          window.location.reload(true);
        }
      });
    });
  }

}

$(document).ready(function() {
  var regularOrderForm = new RegularOrderForm();
  regularOrderForm.initialize();
})
