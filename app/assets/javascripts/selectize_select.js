$(function() {
  $('#select-company').selectize({
    create: true,
    sortField: 'text'
  });

  $('#select-vendor').selectize({
    create: true,
    sortField: 'text'
  });

  $('#sales-rep').selectize({
    create: true,
    sortField: 'text'
  });

  $('#location').selectize({
    create: true,
    sortField: 'text'
  });

  $('#shipvia').selectize({
    create: true,
    sortField: 'text'
  });

  $(function() {
    $('.select-po').selectize({
        //maxItems: 10
    });

    $('.select-vendor').selectize({
        //maxItems: 10
    });
  });
});
