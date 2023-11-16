Rails.application.routes.draw do

  scope module: :admin do
    devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
    }
    get 'admin' => 'homes#top', as: 'admin'
    get 'admin/recipes/:recipe_id/recipe_steps' => 'recipe_steps#index', as: 'admin_recipe_steps'
    resources :genres, only: [:new, :edit, :create, :update]
    get 'admin/genres/search' => 'recipes#genre_search', as: 'admin_genre_search'
    get 'admin/tags/search' => 'tags#tag_search', as: 'admin_tag_search'
    get 'admin/words/search' => 'recipes#word_search', as: 'admin_word_search'
  end

  namespace :admin do
    resources :users ,only: [:show, :update]
    resources :recipes ,only: [:index, :show, :update] do
      resources :recipe_comments ,only: [:index, :show, :update]
    end
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
    resources :users, only: [:index, :show, :edit, :update] do
      resource :user_relationships, only: [:create, :destroy]
    end
    resources :chats, only: [:show, :create]
    resources :recipes do
      resources :recipe_materials, only: [:new, :index, :create, :destroy]
      resources :recipe_steps, only: [:new, :index, :create, :destroy]
      resources :recipe_comments, only: [:new, :index, :create, :show, :destroy]
      resource :favorites, only: [:create, :destroy]
    end
    get 'genres/search' => 'recipes#genre_search', as: 'genre_search'
    get 'tags/search' => 'tags#tag_search', as: 'tag_search'
    get 'words/search' => 'recipes#word_search', as: 'word_search'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
