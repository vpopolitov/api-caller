class TestAdapter < ApiCaller::Adapter
  #get 'url_template', as: :test_route

  use_base_url 'https://api.stackexchange.com/2.2/'
  get 'badges/{badge_id}{?order,sort,site}', as: :test_route
end