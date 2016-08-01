module IdpCaptcha
  class CacheProxy
    class << self
      %i(write fetch delete).each do |m|
        define_method m do |*args, &block|
          IdpCaptcha.config.cache_proxy.send(m, *args, &block)
        end
      end
    end
  end
end
