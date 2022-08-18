require 'uri'
require 'nanoid'

class UrlsController < ApplicationController
  protect_from_forgery with: :null_session

  BASE_URL = 'http://short.est/'

  before_action :set_input_url

  def encode
    return render :json => { message: 'Invalid url' }, :status => 400 unless valid_url?

    short_url = Url.find_by(long_url: input_url)&.short_url || new_url.short_url

    return render :json => { short_url: short_url }
  end
  
  def decode
    return render :json => { message: 'Invalid url' }, :status => 400 unless valid_url?

    url_code = input_url.split('/').last
    long_url = Url.find_by(url_code: url_code)&.long_url

    return render :json => { message: 'Cannot find corresponding url' }, :status => 404 unless long_url
    return render :json => { long_url: long_url }
  end

  private
    attr_reader :input_url

    def url_params
      params.permit(:url)
    end

    def valid_url?
      uri = URI.parse(input_url)
      uri.is_a?(URI::HTTP) && !uri.host.nil?
    rescue URI::InvalidURIError
      false
    end

    def new_url
      url_code = Nanoid.generate(size: 12)
      new_url = Url.new(long_url: input_url, url_code: url_code, short_url: BASE_URL + url_code)
      new_url.save

      new_url 
    end
    
    def set_input_url
      @input_url = url_params[:url]
    end
end
