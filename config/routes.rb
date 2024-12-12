Rails.application.routes.draw do
  root "csv#new"
  
  resources :csv, only: [:new, :create] do
    collection do
      get :progress  # Route for progress polling
      get :show, as: :show  # Explicitly add a named route for the show action
    end
  end
end
