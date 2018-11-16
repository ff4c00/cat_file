module CatFile
  module ApplicationHelper

    def error_message(title: '访问遇到问题问题', message: '修复中,请稍候...')
      "
      <div class='error-message'>
        <h1> #{title} <p></h1>
        <p> #{message} </p>
      </div>
      ".html_safe
    end 
  end
end
