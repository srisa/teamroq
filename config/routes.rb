
Teamroq::Application.routes.draw do
  
  root :to => 'activities#index'
 

  get '/todos/:todo_id/activitycomments/:activity_id', :to => "comments#activitycomments"
  get '/answers/:answer_id/activitycomments/:activity_id', :to => "comments#activitycomments"
  get '/questions/:question_id/activitycomments/:activity_id', :to => "comments#activitycomments"
  get '/discussions/:discussion_id/activitycomments/:activity_id', :to => "comments#activitycomments"
  get '/posts/:post_id/activitycomments/:activity_id', :to => "comments#activitycomments"
  
  get 'todo_lists/:todo_list_id/todos/searchuser', to: 'todos#searchuser'
  get 'projects/:project_id/discussions/searchuser', to: 'discussions#searchuser'
  get '/todos/addwatcher_task', to: 'todos#searchuser'
  get '/todos/searchuser', to: 'todos#searchuser'
  post '/projects/add_users', to: 'projects#add_users'
  post '/groups/add_users', to: 'groups#add_users'

  get 'comments/showcomment', to: 'comments#showcomment'

  get "notifications/index"
  get "notifications/show"
  get "notifications/showall"
  
  get 'documents',:controller =>'users',:action=>'documents'
  get 'tasks',:controller =>'users',:action=>'tasks'
  get 'tasks/closed', :controller => 'users', :action => 'closed'
  get 'tasks/created',:controller =>'users',:action=>'created_open_tasks'
  get 'tasks/created/closed', :controller => 'users', :action => 'created_closed_tasks'
  get 'myquestions(/:filter)',:controller =>'users',:action=>'myquestions'
  get 'mytopics(/:filter)',:controller =>'users',:action=>'mytopics'

  patch "/topics/:name/follow" ,:to => "topic_follower#create"
  patch "/topics/:name/unfollow" ,:to => "topic_follower#destroy"

  get 'topics/:tag(/:filter)', to: 'questions#topic', as: :tag
  get 'search/autocomplete', to: 'search#autocomplete'
  get 'search/autocomplete_tag', to: 'search#autocomplete_tag'
  get 'search/autocomplete_user', to: 'search#autocomplete_user'

  post '/projects/:project_id/attachments',:to => "documents#attachment"
  post '/groups/:group_id/attachments',:to => "documents#attachment"
  
  
  resources :projects  do
    member do
      patch 'add_user',:to => "project_roles#create"
      patch 'remove_user',:to => "project_roles#destroy"
      get 'documents(/filter/:filter)', :to => "projects#documents"
      get 'standup', :to => "projects#standup"
      get 'users'
    end
    resources :documents do 
      resources :document_versions do
        get 'download'
      end
      member do
        get 'download'
      end
    end
    resources :todo_lists do
      member do
        get 'closed'
      end
    end
    resources :discussions do
      collection do
        get 'filter/:filter' ,:to => "discussions#index"
      end
      member do
        patch 'follow' ,:controller =>'discussion_followers',:action=>'create'
        patch 'add_followers' ,:controller =>'discussion_followers',:action=>'add_followers'
        patch 'unfollow',:controller =>'discussion_followers',:action=>'destroy'
      end
    end
  end


  resources :todo_lists do
    resources :todos do
      member do
        patch 'follow' ,:controller =>'todo_followers',:action=>'create'
        patch 'add_followers' ,:controller =>'todo_followers',:action=>'add_followers'
        patch 'unfollow',:controller =>'todo_followers',:action=>'destroy'
        patch 'close'
        patch 'reopen'
        patch 'state_history'
        patch 'change_date'     
        patch 'change_user' 
      end
    end
  end

  resources :todos do
    resources :comments do
      post 'activity_comment', on: :collection
    end
  end

  resources :groups do
    member do
      # post 'attachments',:to => "documents#attachment"
      patch 'add_user', :to => "group_roles#create"
      patch 'remove_user',:to => "group_roles#destroy"
      get 'documents(/filter/:filter)', :to => "groups#documents"
      get 'users'
    end
    resources :announcements
    resources :documents do 
       resources :document_versions do
        get 'download'
      end
      member do
        get 'download'
      end
    end
    resources :posts do
      member do
        patch 'follow'
        patch 'unfollow'
        patch 'add_followers'
      end
    end
  end


  resources :activities

  resources :discussions do
    resources :comments do
      post 'activity_comment', on: :collection
    end
  end

  devise_for :users, :controllers => { :passwords => 'passwords'}, :path_names => { :sign_in => "login", :sign_out => "logout"}
  
  resources :posts do
    resources :comments do
      post 'activity_comment', on: :collection
    end
  end

  resources :questions do
    resources :comments do
      post 'activity_comment', on: :collection
    end
    member do
      patch 'untag'
      patch 'tag'
      patch 'follow' ,:controller =>'question_followers',:action=>'create'
      patch 'unfollow',:controller =>'question_followers',:action=>'destroy'
      post :vote
    end
    resources :answers
  end

  resources :answers do
    resources :comments do
      post 'activity_comment', on: :collection
    end 
    member do
      post :vote
      post :markanswer
    end
  end

  resources :users do
    resources :posts
    member do
      patch 'follow',:controller =>'followers',:action=>'create'
      patch 'unfollow',:controller =>'followers',:action=>'destroy'
    end
  end

end
