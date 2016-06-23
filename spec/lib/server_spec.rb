require 'spec_helper'

RSpec.describe IdpCaptcha::Server do
  before { Rails.cache.clear }

  describe '#code' do
    subject { IdpCaptcha::Server.code }

    it { is_expected.to be_kind_of String }

    it 'writes key to cache' do
      key = subject

      expect(Rails.cache.fetch("idpcaptcha/#{key}1")).to be_falsey
      expect(Rails.cache.fetch("idpcaptcha/#{key}")).to be_truthy
    end

    context 'when it is called multi times' do
      it 'returns different data' do
        key1 = IdpCaptcha::Server.code
        key2 = IdpCaptcha::Server.code

        expect(key1).not_to eq key2
      end
    end
  end

  describe '#show' do
    before(:example) do
      @key = 'key'
      text = 'image'
      Rails.cache.write("idpcaptcha/#{@key}", text)
      allow(IdpCaptcha::Image).to receive(:create).with(text).and_return true
    end

    it 'renders the image' do
      expect(IdpCaptcha::Server.show(@key)).to be true
    end

    context 'when the text cannot be found' do
      it 'raise not exist error' do
        expect { IdpCaptcha::Server.show('not-exist') }
          .to raise_error(IdpCaptcha::Server::NotExist)
      end
    end
  end

  describe '#destroy' do
    before(:example) do
      @key = 'key'
      @text = 'text'
      Rails.cache.write("idpcaptcha/#{@key}", @text)
    end

    subject { IdpCaptcha::Server.destroy(@key, @text) }

    it 'removes the captcha in cache' do
      expect { subject }.to change { Rails.cache.fetch("idpcaptcha/#{@key}") }
    end

    context 'when key and text not match' do
      subject { IdpCaptcha::Server.destroy(@key, 'incorrect') }

      it { is_expected.to be false }
    end

    context 'when user input is empty' do
      subject { IdpCaptcha::Server.destroy('a', nil) }

      it { is_expected.to be false }
    end
  end
end
