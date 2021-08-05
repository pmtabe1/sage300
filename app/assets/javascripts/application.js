// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require jquery-ui
//= require best_in_place
//= require best_in_place.jquery-ui
//= require jquery.turbolinks
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require bootstrap
//= require selectize
//= require trix
//= require Chart.bundle
//= require chartkick
//= require_directory ./accpac
//= require fullcalendar/moment.min.js
//= require fullcalendar/fullcalendar.min.js
//= require daterangepicker/daterangepicker.js
//= require slick/slick.min.js
//= require toastr/toastr.min.js
//= require footable/footable.all.min.js
//= require_tree .
//= require metisMenu/jquery.metisMenu.js
//= require pace/pace.min.js
//= require peity/jquery.peity.min.js
//= require slimscroll/jquery.slimscroll.min.js
//= require inspinia.js
//= require blueimp/jquery.blueimp-gallery.min.js
//= require codemirror/codemirror.js
//= require codemirror/mode/javascript/javascript.js
//= require signature_pad

$(function(){
  if ($('#map').length > 0){
    var google_map = $('meta[name=google_maps]').attr("content");
    $.getScript('https://maps.googleapis.com/maps/api/js?key=GOOGLE_MAP_KEY&callback=initMap');
  }
})
