# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Urls', type: :request do
  describe 'POST /encode' do
    context 'valid url' do
      it 'returns short url' do
        post '/encode', params: { url: 'https://github.com/radeno/nanoid.rb' }
        expect(JSON.parse(response.body)['short_url']).to match('http://short.est/')
        expect(response.status).to eq(200)
      end
    end

    context 'invalid url' do
      it 'returns invalid url' do
        post '/encode', params: { url: 'abc' }
        expect(JSON.parse(response.body)['message']).to eq('Invalid url')
        expect(response.status).to eq(400)
      end
    end
  end

  describe 'POST /decode' do
    context 'valid short url' do
      it 'returns short url' do
        post '/encode', params: { url: 'https://github.com/radeno/nanoid.rb' }
        short_url = JSON.parse(response.body)['short_url']
        post '/decode', params: { url: short_url }
        expect(JSON.parse(response.body)['long_url']).to eq('https://github.com/radeno/nanoid.rb')
        expect(response.status).to eq(200)
      end
    end

    context 'invalid url' do
      it 'returns invalid url' do
        post '/decode', params: { url: 'abc' }
        expect(JSON.parse(response.body)['message']).to eq('Invalid url')
        expect(response.status).to eq(400)
      end
    end

    context 'no corresponding long url' do
      it 'returns no url found' do
        post '/decode', params: { url: 'http://short.est/aNwNrkbSAd_Y' }
        expect(JSON.parse(response.body)['message']).to eq('Cannot find corresponding url')
        expect(response.status).to eq(404)
      end
    end
  end
end
