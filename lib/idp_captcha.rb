require 'rails'
require 'idp_captcha/engine'

require 'idp_captcha/configuration'
require 'idp_captcha/image'

require 'idp_captcha/server'

module IdpCaptcha
  class << self
    def config
      return @config if defined?(@config)

      @config = Configuration.new
      @config.len         = 4
      @config.font_size   = 70
      @config.implode     = 0.4
      @config.cache_limit = 100
      @config.expires_in  = 2.minutes
      @config.style       = :gray
      @config
    end

    def configure(&block)
      config.instance_exec(&block)
    end
  end
end
