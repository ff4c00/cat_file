Rails.application.routes.draw do
  mount CatFile::Engine => "/cat_file"
end
