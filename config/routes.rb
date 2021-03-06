class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(
      Rails.root.join("config/routes/#{routes_name}.rb")
    ))
  end
end

Upcase::Application.routes.draw do
  use_doorkeeper

  draw :admin
  draw :api
  draw :books
  draw :pages
  draw :plan
  draw :podcasts
  draw :products
  draw :redirects
  draw :repositories
  draw :shows
  draw :stripe
  draw :subscriber
  draw :teams
  draw :trails
  draw :landing_pages
  draw :users
  draw :video_tutorials

  root to: "homes#show"

  resource :annual_billing, only: [:new, :create]
  resource :credit_card, only: [:update]
  resource :session, controller: :sessions
  resource :forum_sessions, only: :new
  resource :subscription, only: [:new, :edit, :update]
  resources :licenses, only: [:index]
  resources :topics, only: :index, path: :trails

  resources :videos, only: [:index, :show] do
    resource :twitter_player_card, only: [:show]
  end

  resources(
    :design_for_developers_resources,
    path: "design-for-developers-resources",
    only: [:index, :show]
  )
  resources(
    :test_driven_rails_resources,
    path: "test-driven-rails-resources",
    only: [:index]
  )

  get "practice" => "practice#show", as: :practice
  get "explore" => "explore#show", as: :explore
  get "sitemap.xml" => "sitemaps#show", as: :sitemap, format: "xml"
  get ":id" => "topics#show", as: :topic
  get ":topic_id/resources" => "resources#index", as: :topic_resources
  get "/auth/:provider/callback", to: "auth_callbacks#create"
end
