require 'spec_helper'

describe 'captcha requests', type: :request do
  describe 'GET' do
    context 'when /idp_captcha/new' do
      it 'responds with id and uri' do
        get '/idp_captcha/new'
        body = JSON.parse(response.body)
        expect(body.keys).to include(* %w(id url))
      end
    end

    context 'when /idp_captcha/:id' do
      before { allow(IdpCaptcha::Server).to receive(:show).and_return 'image' }

      it 'generates an image' do
        get '/idp_captcha/key'
        expect(response.header['Content-Type']).to eq 'image/png'
        expect(response.body).to eq 'image'
      end

      context 'when the key is invalid' do
        before do
          allow(IdpCaptcha::Server)
            .to receive(:show).and_raise(IdpCaptcha::Server::NotExist)
        end

        it 'returns 404' do
          expect { get '/idp_captcha/key' }
            .to raise_error ActionController::RoutingError
        end
      end
    end
  end

  describe 'DELETE' do
    context 'when /idp_captcha/:key' do
      let(:key) { 'key' }
      let(:value) { 'value' }

      before { allow(IdpCaptcha::Server).to receive(:destroy).and_return true }

      it 'returns a result json' do
        delete "/idp_captcha/#{key}", captcha: value

        body = JSON.parse(response.body)
        expect(body['result']).to be true
      end
    end
  end
end
