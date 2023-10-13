Rails.application.routes.draw do
  
  scope module: :admin do
    devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
    }
    get 'admin' => 'homes#top', as: 'admin'
    resources :genres, only: [:new, :edit, :create, :update]
  end

  scope module: :public do
    root to: 'homes#top'
    devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
    }
    devise_scope :user do
    post "users/guest_sign_in", to: "sessions#guest_sign_in"
    end
    resources :users, only: [:index, :show, :edit, :update]
    resources :recipes do
      resources :recipe_materials, only: [:new, :index, :create, :destroy]
      resources :recipe_steps, only: [:new, :index, :create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end
    get 'genres/search' => 'recipes#genre_search', as: 'genre_search'
    get 'tags/search' => 'tags#tag_search', as: 'tag_search'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
