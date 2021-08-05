var formatter = new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    minimumFractionDigits: 2,
  });

this.initMap = function() {
    var bounds, customers, map;
    map = new GMaps({
      div: '#map',
      lat: 38.5816,
      lng: -121.4944
    });
    window.map = map;
    customers = JSON.parse(document.querySelector('#map').dataset.customers);
    window.customers = customers;
    bounds = new google.maps.LatLngBounds;
    customers.forEach(function(customer) {
      var marker;
      if (customer.latitude && customer.longitude) {
        if (customer.budgeted > customer.netsales) {
            marker = map.addMarker({
                lat: customer.latitude,
                lng: customer.longitude,
                title: customer.name,
                icon: {
                    url: "http://maps.google.com/mapfiles/ms/icons/green-dot.png"
                },
                infoWindow: {
                    content: `<h3>${customer.uniq}</h3><h4><a href='/accpac/customers/${customer.uniq}' target='_blank'>${customer.name}</a></h4><h5>Budget: ${formatter.format(customer.budgeted)}</h5><h5>Netsales: ${formatter.format(customer.netsales)}</h5>`
                }
              });
              bounds.extend(marker.position);
          }
        else {
            marker = map.addMarker({
                lat: customer.latitude,
                lng: customer.longitude,
                title: customer.name,
                icon: {
                    url: "http://maps.google.com/mapfiles/ms/icons/red-dot.png"
                },
                infoWindow: {
                    content: `<h3>${customer.uniq}</h3><h4><a href='/accpac/customers/${customer.uniq}' target='_blank'>${customer.name}</a></h4><h5>Budget: ${formatter.format(customer.budgeted)}</h5><h5>Netsales: ${formatter.format(customer.netsales)}</h5>`
                }
              });
              bounds.extend(marker.position);
        }
      }
    });
    map.fitBounds(bounds);
  };
