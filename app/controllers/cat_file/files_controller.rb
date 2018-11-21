require_dependency "cat_file/application_controller"

module CatFile
  class FilesController < ApplicationController

    def index
      
    end 

    def files_list
      res = CatFile::Directory.dir_files
      return (render json: res) unless res[0]
        
      tmp = []
      res[1].each do |k,v|
        tmp << {title: k, names: v }
      end 

      res = {file_names: tmp, file_lables: res[1].keys }
      render json: res
    end
    
    def get_file_names
      res = CatFile::Directory.dir_files
      return (render json: res) unless res[0]
      
      values = res[1].values.compact.flatten
      tmp = []
      values.each do |value|
        tmp << {value: value}
      end 
      render json: tmp
    end 

    def file_detail
      @res = CatFile::FileContent.cat(path: "log/#{params[:file_name]}", check_size: false)
      return @res unless @res[0]
      res = FileContent.size(path: "log/#{params[:file_name]}")
      return @res = res unless res[0]
      file_size = res[1]
      @res = [true, {file_name: params[:file_name], file_size: file_size, file_detail: @res[1]}]
    end 


  end 
end