Myaka::Application.routes.draw do
  constraints lambda {|req| req.headers['Host'] == Myaka::Application.config.myaka_domain } do
    resources :akas
    put '/', to: 'akas#update_current'
    resources :sessions, only: [:new, :create, :destroy]
    resources :profile_links
    root to: 'static_pages#home'
    get '/loginhelp', to: 'static_pages#login_help'
    post '/loginhelp', to: 'static_pages#send_login_help_email'
    get '/loginhelp/reset', to: 'static_pages#begin_reset'
    post '/loginhelp/reset', to: 'static_pages#finish_reset'
    match '/signup', to: 'akas#new'
    match '/signin', to: 'sessions#new'
    match '/signout', to: 'sessions#destroy'
    match '/openid', to: 'openid#main'
    get '/editprofile', to: 'akas#profile_editor'
    post '/editprofile', to: 'akas#edit_profile'
    post '/openid/confirm', to: 'openid#confirm'
    get '/hub', to: 'pubsubhubbub#info'
    post '/hub', to: 'pubsubhubbub#register'
    get '/privacy', to: 'static_pages#privacy'
    delete '/trustroot/:id', to: 'akas#remove_trust_root'
    get '/unsubscribe', to: 'mailing_list#unsubscribe'
    post '/import', to: 'io#import'
    get '/export', to: 'io#export'
    if Myaka::Application.config.profile_preview_domain == Myaka::Application.config.myaka_domain
      post '/preview-profile', to: 'akas#preview_profile'
    end
  end

  constraints lambda {|req| (req.headers['Host'] != Myaka::Application.config.myaka_domain and
                             req.headers['Host'] != Myaka::Application.config.profile_preview_domain) } do
    root to: 'profile#home'
    match '/.well-known/host-meta', to: 'profile#host_meta', defaults: { format: :xrd }
  end

  if Myaka::Application.config.backend_domain
    constraints lambda {|req| (req.headers['Host'] == Myaka::Application.config.backend_domain)} do
      match '/backend/:subdomain/', to: 'profile#home'
      match '/backend/:subdomain/.well-known/host-meta', to: 'profile#host_meta', defaults: { format: :xrd }
    end
  end

  if Myaka::Application.config.profile_preview_domain != Myaka::Application.config.myaka_domain
    constraints lambda {|req| req.headers['Host'] == Myaka::Application.config.profile_preview_domain} do
      post '/preview-profile', to: 'profile#preview'
    end
  end

end
