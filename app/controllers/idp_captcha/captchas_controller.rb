module IdpCaptcha
  class CaptchasController < ActionController::Base
    def new
      key = IdpCaptcha::Server.code
      render json: { id: key, url: idp_captcha_image_url(key) }
    end

    def validate
      result = IdpCaptcha::Server.destroy(params[:key], params[:captcha])

      render json: { result: result }
    end
    alias destroy validate

    def show
      headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
      headers['Pragma'] = 'no-cache'

      image = IdpCaptcha::Server.show(params[:key])

      if Gem.win_platform?
        send_file image, disposition: 'inline', type: 'image/png'
      else
        send_data image, disposition: 'inline', type: 'image/png'
      end
    rescue IdpCaptcha::Server::NotExist
      raise ActionController::RoutingError, 'Not Found'
    end
  end
end
