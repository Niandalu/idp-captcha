IdpCaptcha::Engine.routes.draw do
  get 'new' => 'captchas#new'
  get ':key' => 'captchas#show', as: 'idp_captcha_image'
  delete ':key' => 'captchas#validate'
end
