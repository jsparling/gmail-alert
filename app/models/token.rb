require 'net/http'
require 'json'

class Token < ActiveRecord::Base
  def to_params
    {
      'refresh_token' => refresh_token,
      # 'client_id' => ENV['CLIENT_ID'],
      # 'client_secret' => ENV['CLIENT_SECRET'],
      'client_id' => '2084bd37-83a4-4589-9b7b-63d4ba2fedb8',
      'client_secret' => 'Ak9rH7u6XIBVgBpGCvRDrETKqdLp2IwTPHicpBLQ9tg=',
      'grant_type' => 'authorization_code',
      # 'grant_type' => 'refresh_token',

    }
  end
  #azure = client = 2084bd37-83a4-4589-9b7b-63d4ba2fedb8
  #key = Ak9rH7u6XIBVgBpGCvRDrETKqdLp2IwTPHicpBLQ9tg=

  def request_token_from_google
    # url = URI("https://accounts.google.com/o/oauth2/token")
    url = URI("https://login.windows.net/10e54b7b-e5df-42d0-a722-a8ef6798c448/oauth2/token?api-version=1.0")
    # url = URI("https://login.windows.net/10e54b7b-e5df-42d0-a722-a8ef6798c448/oauth2/authorize?api-version=1.0")
    Net::HTTP.post_form(url, self.to_params)
  end

  def refresh!
    response = request_token_from_google
    data = JSON.parse(response.body)
    puts data.inspect
    update_attributes(
      access_token: data['access_token'],
      expires_at: Time.now + (data['expires_in'].to_i).seconds
      )
  end

  def expired?
    expires_at < Time.now
  end

  def fresh_token
    refresh! if expired?
    access_token
  end

end
