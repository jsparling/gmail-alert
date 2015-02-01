require 'viewpoint'
require 'time'

class SessionsController < ApplicationController
  layout false
   include Viewpoint::EWS

  def new


    #this was in the new method.
        # EWS, works but not secure i think
    # Make sure you uncomment the include for Viewpoint
    endpoint = 'https://outlook.office365.com/ews/Exchange.asmx'
    user = 'jsparling@avvo.com'
    pass = 'tbsSTD11'


    @cli = Viewpoint::EWSClient.new endpoint, user, pass

    calendar = @cli.get_folder(:calendar)

    @event_list = calendar.items


  end

  def create
    require 'byebug'
    byebug
    # What data comes back from OmniAuth?
    @auth = request.env["omniauth.auth"]
    @credentials = @auth['credentials']

    @token = @credentials["token"]
    provider = @auth.provider

    Token.create(
      provider: provider,
      access_token: @credentials['token'],
      refresh_token: @credentials['refresh_token'],
      expires_at: Time.at(@credentials['expires_at']).to_datetime)

    calendar_list(@token)
  end

  def calendar
    last_token = Token.last

    @result = calendar_list(last_token.fresh_token)

    @calendar_list = JSON.parse(@result.data.to_json)
  end

  def events
    last_token = Token.last

    @result = get_events(last_token.fresh_token, "jake.sparling@gmail.com")
    # require 'byebug'
    # byebug
    # @events = @result.data
    @events = @result

  end

  def get_events(token, calendar_id)
    client = Google::APIClient.new
    client.authorization.access_token = token
    service = client.discovered_api('calendar', 'v3')

    # do do other stuff, change api_method and parameters:
    # https://developers.google.com/google-apps/calendar/v3/reference/
    page_token = nil
    result = client.execute(
      :api_method => service.events.list,
      :parameters => {
        :calendarId => calendar_id,
        :maxResults => 250,
        :timeMin => "2014-11-11T09:00:00-08:00",
        :timeMax => "2015-12-31T09:00:00-08:00",
        :singleEvents => true,
        :orderBy => "startTime",
        }
      )
    event_list = []
    while true
      event_list << result.data.items
      if !(page_token = result.data.next_page_token)
        break
      end
      result = client.execute(
        :api_method => service.events.list,
        :parameters => {
          :calendarId => calendar_id,
          :maxResults => 250,
          :timeMin => "2014-11-11T09:00:00-08:00",
          :timeMax => "2015-12-31T09:00:00-08:00",
          :singleEvents => true,
          :orderBy => "startTime",
          :pageToken => page_token,
          }
        )
    end
    event_list
    # client.execute(
    #   :api_method => service.events.list,
    #   :parameters => {
    #     :calendarId => calendar_id,
    #     :maxResults => 50,
    #     :timeMin => "2014-11-11T09:00:00-08:00",
    #     :timeMax => "2015-12-31T09:00:00-08:00",
    #     :singleEvents => true,
    #     :orderBy => "startTime",
    #     },
    #   :headers => {'Content-Type' => 'application/json'})
  end


  def calendar_list(token)
    client = Google::APIClient.new
    client.authorization.access_token = token
    service = client.discovered_api('calendar', 'v3')

    # do do other stuff, change api_method and parameters:
    # https://developers.google.com/google-apps/calendar/v3/reference/
    client.execute(
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
