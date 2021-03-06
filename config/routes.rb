Rails.application.routes.draw do

  namespace :api do
    scope :laboratory do
      # TODO: need to test this with a embedded system
      post 'computer/:id' => 'status#new_computer', :defaults => { :format => :json }
      post 'status/' => 'status#new_laboratory', :defaults => { :format => :json }
    end

    # TODO: need to test this routes with orangepi
    # orangepi
    scope 'fingerprint' do
      post '/' => 'biometric#get'
      post '/access/' => 'biometric#create_access'
      post '/new/' => 'biometric#create'
    end
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => "users/registrations"

  }

  resources :laboratory do
    post 'reports/' => "report#create"
    get 'reports/' => "report#show"
    get '/subjects' => 'laboratory#subjects', :defaults => { :initials => "LSO" }
    get '/map' => 'laboratory#map', :defaults => { :initials => "LSO" }
  end

  scope 'dashboard' do
    get '/' => 'dashboard#index', as: :dashboard_root
    get 'profile/' => 'dashboard#profile'
    get 'help/' => 'dashboard#help'

    patch 'edit/' => 'dashboard#edit', as: :dashboard_edit_profile

    scope ':laboratory_initials' do
      get 'reports/' => 'dashboard#report', as: :dashboard_reports
      patch 'reports/' => 'report#edit', as: :dashboard_reports_edit

      get 'map/' => 'dashboard#map', as: :dashboard_map
      get 'statistics/' => 'dashboard#statistics', as: :dashboard_statistics
      get 'embedded/' => 'dashboard#embedded', as: :dashboard_embedded
      #get 'users/' => 'dashboard#embedded', as: :dashboard_embedded

      scope 'access' do
        get '/' => 'dashboard#access', as: :dashboard_access
        post '/' => 'authorized_person#save', as: :dashboard_access_create
        post '/pause' => 'authorized_person#pause', as: :dashboard_access_pause
        post '/unpause' => 'authorized_person#unpause', as: :dashboard_access_unpause
        post '/extend' => 'authorized_person#extend', as: :dashboard_access_extend
        delete '/delete' => 'authorized_person#delete', as: :dashboard_access_delete
        get 'fingerprint/' => 'authorized_person#get_biometric', as: :dashboard_access_fingerprint
        get 'students/' => 'dashboard#students', as: :dashboard_access_students
        get 'students/csv' => 'dashboard#students_csv', as: :dashboard_access_students_csv, defaults: { format: :csv }
      end
    end
  end

  get 'about/' => 'application#about'
  root 'laboratory#show'

end
