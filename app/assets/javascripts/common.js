$(document).ready(function(){
  // Reset the checkbox if the page is reloaded
  $('#date-range-checkbox')[0].checked = false;

  $( "#toggle-button" ).click(function(event) {
    event.preventDefault();
    $('#date-select-end').toggle();
    var checked = $('#date-range-checkbox')[0].checked;
    $('#date-range-checkbox')[0].checked = (checked) ? false : true;
  });
});
