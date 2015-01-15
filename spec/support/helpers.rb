class TestAdapter < ApiCaller::Adapter
  get 'url_pattern', as: :test_route
end