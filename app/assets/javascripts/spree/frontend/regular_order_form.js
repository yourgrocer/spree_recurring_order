function RegularOrderForm() {

  var that = this;
  this.initialize = function(){
    $("#recurring-order-form a.delete").click(function(){
      var ids = this.attributes["id"].value.replace("delete_","").split('_');
      var listId = ids[0];
      var itemId = ids[1];

      $.ajax({
        url: 'api/recurring_lists/' + itemId,
        type: 'PUT',
        data: {recurring_list_item: {id: itemId, destroy: true}},
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
