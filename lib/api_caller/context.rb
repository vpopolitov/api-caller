module ApiCaller
  Context = Struct.hash_initialized :http_verb, :base_url, :url, :params, :body, :headers
end