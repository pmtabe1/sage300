unless Rails.env.test? || Rails.env.development?
  Searchkick.client =
    Elasticsearch::Client.new(
      url: ENV.fetch('ELASTICSEARCH_URL'),
      transport_options: {
        request: {
          timeout: Searchkick.timeout
        }
      }
    )
end
