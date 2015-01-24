GmailAlerts::Application.routes.draw do
  root to: 'sessions#new'

  resources :sessions, :only => [:index] do
    get :calendar, :on => :collection
  end


  get "/auth/:provider/callback" => 'sessions#create'

end
