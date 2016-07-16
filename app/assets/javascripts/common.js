$(document).ready(function(){
  $( "#toggle-button" ).click(function(event) {
    event.preventDefault();
    $('#date-select-end').toggle();
  });
});
