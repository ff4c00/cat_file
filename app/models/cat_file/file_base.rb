module CatFile
  class FileBase < ApplicationRecord 

    FILE_TYPE ={ 
      'file' => '普通文件',
      'directory' => '目录',
      'characterSpecial' => '字符特殊文件',
      'blockSpecial' => '块特殊文件',
      'fifo' => '命名管道(FIFO)',
      'link' => '符号链接',
      'socket' => 'Socket',
      'unknown' => '未知的文件类型'
    }

    class << self 

      # 获取文件或文件夹的绝对路径
      def to_path(path: nil, is_exist: true, is_dir: false, is_common_file: nil, check_size: true, file_size: 3072)
        return [false, '路径参数为空'] if path.nil?
        path = Rails.root.join(path)
        path = File::split(path).join('/')

        if is_exist
          # TODO: 如果不存在,新建该路径
          res = exist(path: path)
          return res unless res[0]
        end 

        unless is_dir
          is_common_file ||= !is_dir

          if is_common_file && is_exist
            res = common_file(path: path, routine_check: false)
            # TODO: 可不可以通过Ruby的奇技淫巧省略下面这行代码
            return res unless res[0]
          end 

          if check_size && is_exist
            res = size(path: path, routine_check: false)
            return res unless res[0]
            return [false, 'EFBIG', "文件大小为:#{res[1]}KB."] if res[1] > file_size
          end 

        else
          # 暂不对文件夹大小设置限定
          return [false, '未找到参数对应文件夹']unless File::directory?(path)
        end 

        [true, path]
      end

      def exist(path: nil)
        return [false, '路径参数为空'] if path.nil?
        return [false, '该路径不存在'] unless File::exist?(path)
        [true, '']
      end 

      def size(path: nil, routine_check: true) 
        if routine_check
          return [false, '路径参数为空'] if path.nil?
          res = exist(path: path)
          return res unless res[0]
        end 
        [true, File::size(path)]
      end 

      def common_file(path: nil, routine_check: true)
        if routine_check
          return [false, '路径参数为空'] if path.nil?
          res = exist(path: path)
          return res unless res[0]
        end 
        unless File::file?(path)
          return [false, "该路径文件为:'#{FILE_TYPE[File::ftype(path)]}',非普通文件."]
        end 
        [true, '']
      end 

    end

  end
end
