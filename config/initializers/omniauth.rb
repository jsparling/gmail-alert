Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['CLIENT_ID'], ENV['CLIENT_SECRET'], {
    access_type: 'offline',
    scope: 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/calendar',
  }
  # provider :google_oauth2, ENV['CLIENT_ID'], ENV['CLIENT_SECRET'], {
  # scope: ['email',
  #   'https://www.googleapis.com/auth/gmail.readonly'],
  #   access_type: 'offline'}
end
