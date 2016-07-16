$(document).ready(function(){
  $( "#toggle-button" ).click(function(event) {
    event.preventDefault();
    $('#date-select-end').toggle();
    var checked = $('#date-range-checkbox')[0].checked;
    $('#date-range-checkbox')[0].checked = (checked) ? false : true;
  });
});
