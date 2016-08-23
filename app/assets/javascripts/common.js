$(document).ready(function(){
  // Reset the checkbox if the page is reloaded
  //
  checkbox = $('#date-range-checkbox')[0];
  if (typeof checkbox !== 'undefined') {
    checkbox.checked = false;
  }

  $( "#toggle-button" ).click(function(e) {
    e.preventDefault();
    $('#date-select-end').toggle();
    var checked = $('#date-range-checkbox')[0].checked;
    $('#date-range-checkbox')[0].checked = (checked) ? false : true;
  });

  $(document).on('click', '.toggle-button', function(e) {
    e.preventDefault();
    $(this).toggleClass('toggle-button-selected'); 
    $('#date-select-end').toggle();
    var checked = $('#date-range-checkbox')[0].checked;
    $('#date-range-checkbox')[0].checked = (checked) ? false : true;
  });
 
});
