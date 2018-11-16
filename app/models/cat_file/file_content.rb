module CatFile
  class FileContent < FileBase
    class << self

      def cat(path: nil, check_size: true)
        return [false, '文件相对路径不能为空'] if path.nil?
        res = to_path(path: path, check_size: check_size)
        return res unless res[0]

        res = to_path(path: path, check_size: check_size)
        res = `cat "#{res[1]}"`
        return [false, '文件读取失败.'] unless $?.to_s.split(' ')[-1] == '0'
        [true, res.split(',')]
      end

    end 
  end 
end