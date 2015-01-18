module ApiCaller
  Request = Struct.hash_initialized :http_verb, :url, :body, :headers
end