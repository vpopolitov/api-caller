# taken from http://stackoverflow.com/questions/2680523/dry-ruby-initialization-with-hash-argument
class Struct
  def self.hash_initialized(*params)
    klass = Class.new(self.new(*params))

    klass.class_eval do
      define_method(:initialize) do |h|
        super(*h.values_at(*params))
      end
    end
    klass
  end
end