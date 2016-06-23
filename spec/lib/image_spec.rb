require 'spec_helper'

RSpec.describe IdpCaptcha::Image do
  describe '.create' do
    it 'creates a png based on given text' do
      output = IdpCaptcha::Image.create('test')
      File.write('/tmp/test.png', output)
      p 'Please examine /tmp/test.png manually'
    end

    it 'generates different image although given the same text' do
      text = 'test'
      output1 = IdpCaptcha::Image.create(text)
      output2 = IdpCaptcha::Image.create(text)

      expect(output1).not_to eq output2
    end
  end
end
