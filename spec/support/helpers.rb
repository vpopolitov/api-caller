class TestAdapter < ApiCaller::Adapter
  get 'url_template', as: :test_route
end