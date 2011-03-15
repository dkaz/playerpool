$(function() {
  $.ajax({
    url: "/players.xml",
    dataType: "xml",
    success: function(response){
      var data = $("player", response).map(function() {
        return {
          value: $("first-name", this).text() + " " + $("last-name", this).text(),
          id: $("id", this).text()
        };
      }).get();
      $('#player_name').autocomplete({
        source: data,
        minLength: 1,
        select: function(event, ui) {
          $('#player_id').attr('value', ui.item.id); 
        }
      });
    }
  });
});
