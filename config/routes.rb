Rails.application.routes.draw do
  
  namespace :public do
    get 'recipe_steps/new'
    get 'recipe_steps/index'
  end
  namespace :public do
    get 'recipe_materials/new'
    get 'recipe_materials/index'
  end
  scope module: :admin do
    devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
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
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
