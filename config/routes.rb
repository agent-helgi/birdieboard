Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions:      "users/sessions"
  }

  # Invitation magic link (public)
  get  "invite/:token", to: "invitations#show",   as: :invitation
  post "invite/:token", to: "invitations#accept",  as: :accept_invitation

  # Player-facing
  namespace :golf do
    resources :tournaments, only: %i[index show] do
      resources :entries, only: %i[new create]
      resources :rounds, only: %i[show] do
        resources :scores, only: %i[new create edit update] do
          member do
            post :submit
            post :approve
          end
        end
      end
    end
  end

  # Organiser admin
  namespace :admin do
    resources :tournaments do
      member do
        post :open
        post :close
      end
      resources :invitations, only: %i[index new create destroy]
      resources :entries,     only: %i[index]
      resources :rounds,      only: %i[new create edit update]
    end

    root to: "tournaments#index"
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root to: redirect("/admin")
end
