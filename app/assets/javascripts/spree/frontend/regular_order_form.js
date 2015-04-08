function RegularOrderForm() {

  var that = this;
  this.initialize = function(){
    $("#recurring-order-form a.delete").click(function(){
      var ids = this.attributes["id"].value.replace("delete_","").split('_');
      var listId = ids[0];
      var itemId = ids[1];

      Spree.ajax({
        url: 'api/recurring_lists/' + listId,
        type: 'PUT',
        headers: {'X-Spree-Token': Spree.api_key},
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
