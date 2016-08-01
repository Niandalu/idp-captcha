module IdpCaptcha
  # Serve captcha image for clients
  class Server
    class NotExist < StandardError; end

    class << self
      def code
        random_key.tap do |key|
          CacheProxy.write("idpcaptcha/#{key}",
                           random_key(length: IdpCaptcha.config.len),
                           expires_in: 2.minutes)
        end
      end

      def show(key)
        text = CacheProxy.fetch("idpcaptcha/#{key}")

        raise NotExist, 'cannot find the captcha with given key' unless text

        Image.create(text)
      end

      def destroy(key, user_input)
        stored_value = CacheProxy.fetch("idpcaptcha/#{key}")
        return false unless stored_value

        valid_input = !user_input.nil? && !user_input.empty?
        return false unless valid_input

        matched = stored_value.casecmp(user_input).zero?
        return false unless matched

        CacheProxy.delete("idpcaptcha/#{key}")
      end

      private

      def random_key(length: 8)
        SecureRandom.hex(length / 2)
                    .downcase.gsub(/[0ol1]/i, (rand(8) + 2).to_s)
      end
    end
  end
end
