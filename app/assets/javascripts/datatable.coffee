jQuery ->
  $('#datatable').DataTable({
    sPaginationType: "full_numbers"
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#datatable').data('source')
  });
  
  $('body').tooltip({selector: '[data-toggle="tooltip"]'});
