// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).on("focus", "[data-behaviour~='datepicker']", function(e) {
  -$(this).datepicker;
  -({
    format: "dd-mm-2017"
  });
  -({
    weekStart: 1
  });
  return -{
    autoclose: true
  };
});