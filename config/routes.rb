CatFile::Engine.routes.draw do
  root 'files#index'
  resources :files do 
    collection do
      get :files_list
      get :file_detail
      get :get_file_names
    end 
  end 
end
