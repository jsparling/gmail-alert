class SessionsController < ApplicationController
  layout false


  def new
  end

  def create
    # What data comes back from OmniAuth?
    @auth = request.env["omniauth.auth"]
    @credentials = @auth['credentials']
    # Use the token from the data to request a list of calendars
    @token = @credentials["token"]

    Token.create(
      access_token: @credentials['token'],
      refresh_token: @credentials['refresh_token'],
      expires_at: Time.at(@credentials['expires_at']).to_datetime)

    calendar_list(@token)
  end

  def calendar
    last_token = Token.last

    calendar_list(last_token.fresh_token)
  end

  def calendar_list(token)
    client = Google::APIClient.new
    client.authorization.access_token = token
    service = client.discovered_api('calendar', 'v3')

    # do do other stuff, change api_method and parameters:
    # https://developers.google.com/google-apps/calendar/v3/reference/
    @result = client.execute(
      :api_method => service.calendar_list.list,
      :parameters => {},
      :headers => {'Content-Type' => 'application/json'})
  end

  def old_create
    @auth = request.env['omniauth.auth']['credentials']

    Token.create(
      access_token: @auth['token'],
      refresh_token: @auth['refresh_token'],
      expires_at: Time.at(@auth['expires_at']).to_datetime)
  end
end
