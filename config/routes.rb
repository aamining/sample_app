SampleApp::Application.routes.draw do
  scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do
    resources :users do
      member do
        get :following, :followers
      end
    end
    resources :sessions,      only: [:new, :create, :destroy]
    resources :microposts,    only: [:create, :destroy]

    match '/signup',  to: 'users#new'
    match '/signin',  to: 'sessions#new'
    match '/signout', to: 'sessions#destroy', via: :delete

    match '/help',    to: 'static_pages#help'
    match '/about',   to: 'static_pages#about'
    match '/contact', to: 'static_pages#contact'

    # handles /en|it|ja
    root to: 'static_pages#home'
    # handles /en|it|ja/fake-path
    match '*path', to: redirect { |params, request| "/#{params[:locale]}" }
  end

  resources :relationships, only: [:create, :destroy]

  # handles /
  root to: redirect("/#{I18n.default_locale}"), as: "non_localized_root"
  # handles /bad-locale|anything/valid-path
  match '/*locale/*path', to: redirect("/#{I18n.default_locale}/%{path}")
  # handles /anything|valid-path-but-no-locale
  match '/*path', to: redirect("/#{I18n.default_locale}/%{path}")

end
#== Route Map
# Generated on 30 Jun 2012 12:49
#
#     followers_user GET    /:locale/users/:id/followers(.:format) users#followers {:locale=>/en|it|ja/}
#              users GET    /:locale/users(.:format)               users#index {:locale=>/en|it|ja/}
#                    POST   /:locale/users(.:format)               users#create {:locale=>/en|it|ja/}
#           new_user GET    /:locale/users/new(.:format)           users#new {:locale=>/en|it|ja/}
#          edit_user GET    /:locale/users/:id/edit(.:format)      users#edit {:locale=>/en|it|ja/}
#               user GET    /:locale/users/:id(.:format)           users#show {:locale=>/en|it|ja/}
#                    PUT    /:locale/users/:id(.:format)           users#update {:locale=>/en|it|ja/}
#                    DELETE /:locale/users/:id(.:format)           users#destroy {:locale=>/en|it|ja/}
#           sessions POST   /:locale/sessions(.:format)            sessions#create {:locale=>/en|it|ja/}
#        new_session GET    /:locale/sessions/new(.:format)        sessions#new {:locale=>/en|it|ja/}
#            session DELETE /:locale/sessions/:id(.:format)        sessions#destroy {:locale=>/en|it|ja/}
#         microposts POST   /:locale/microposts(.:format)          microposts#create {:locale=>/en|it|ja/}
#          micropost DELETE /:locale/microposts/:id(.:format)      microposts#destroy {:locale=>/en|it|ja/}
#             signup        /:locale/signup(.:format)              users#new {:locale=>/en|it|ja/}
#             signin        /:locale/signin(.:format)              sessions#new {:locale=>/en|it|ja/}
#            signout DELETE /:locale/signout(.:format)             sessions#destroy {:locale=>/en|it|ja/}
#               help        /:locale/help(.:format)                static_pages#help {:locale=>/en|it|ja/}
#              about        /:locale/about(.:format)               static_pages#about {:locale=>/en|it|ja/}
#            contact        /:locale/contact(.:format)             static_pages#contact {:locale=>/en|it|ja/}
#               root        /:locale(.:format)                     static_pages#home {:locale=>/en|it|ja/}
#                           /:locale/*path(.:format)               :controller#:action {:locale=>/en|it|ja/}
#      relationships POST   /relationships(.:format)               relationships#create
#       relationship DELETE /relationships/:id(.:format)           relationships#destroy
# non_localized_root        /                                      :controller#:action
