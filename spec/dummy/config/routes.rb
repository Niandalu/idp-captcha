Rails.application.routes.draw do
  mount IdpCaptcha::Engine => '/idp_captcha'
end
