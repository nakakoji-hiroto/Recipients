Rails.application.routes.draw do
  
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
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
