Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :comics, only: %i[index]
      resources :games, only: %i[create update] do
        resource :progresses, only: %i[new create]
        member do
          get :challenge
        end
      end
    end
  end
end
