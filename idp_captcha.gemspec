$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'idp_captcha/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'idp_captcha'
  s.version     = IdpCaptcha::VERSION
  s.authors     = ['Niandalu']
  s.email       = ['niandalu@gmail.com']
  s.homepage    = 'https://github.com/huacnlee/rucaptcha'
  s.summary     = 'Captcha as service'
  s.license     = 'MIT'

  s.files = Dir.glob('lib/**/*') + Dir.glob('app/**/*') +
            Dir.glob('config/**/*')
  s.test_files = Dir.glob('spec/**/*')

  s.add_dependency 'rails', '>= 3.2'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'pry-rails'
end
