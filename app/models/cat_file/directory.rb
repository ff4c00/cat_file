module CatFile
  class Directory < FileBase
    DEFAULT_PATH = 'log'
    SORT_RULES = [
      {"regular"=>"([a-zA-Z0-9]+Interface|[a-zA-Z0-9]+_log_p)", "zh_name"=>"电商接口日志", "index"=>2},
      {"regular"=>"[a-z_]+exception", "zh_name"=>"类异常日志", "index"=>0}
    ]
    SURPLUS_FILE_CLASS_NAME = '其他文件'

    class << self
      
      # 获取文件夹内文件名称分类集合
      def dir_files(path: DEFAULT_PATH, show_hide_file: false, sort_file_name: true, sort_rules: SORT_RULES)
        res = each_dir(path: path, show_hide_file: show_hide_file)
        return res unless res[0]
        file_name_array = res[1]
        result = [true, {'所有文件' => file_name_array}]

        # 根据分类规则分类
        if sort_file_name
          return [false, '文件分类规则不能为空'] if sort_rules.nil?

          tmp_hash = {}
          sort_rules.each do |hash|
            res = sort_file(file_name_array: file_name_array, sort_rule: hash)
            return res unless res[0]
            tmp_hash.merge!(res[1])
          end 

          # 分类剩余文件归类
          orther_array = file_name_array - tmp_hash.values.flatten
          tmp_hash[SURPLUS_FILE_CLASS_NAME] = orther_array

          # 根据规则中的index进行分类排序 
          res = order_with_index(file_name_hash: tmp_hash)
          return res unless res[0]

          result = [true, res[1]]
        end
        result
      end 

      # 迭代文件夹内文件名称
      def each_dir(path: DEFAULT_PATH, show_hide_file: false, time_sort: true)
        tmp = []
        res = to_path(path: path, is_dir: true)
        return res unless res[0]
        dir_path = res[1]
        
        Dir.foreach(dir_path) do |file_name|
          if (file_name != ".") && (file_name != "..")
            (next unless (file_name =~/^\.[a-z A-Z 0-9]+/).nil?) unless show_hide_file
            tmp << file_name
          end
        end

        # 根据文件更新时间排序
        if time_sort
          res = sort_by_update_time(file_name_array: tmp, dir_path: path)
          return res unless res[0]
          tmp = res[1]
        end

        [true, tmp]
      end

      # 对文件名的数组集合进行分类
      def sort_file(file_name_array: nil, sort_rule: nil)
        return [false, '文件名集合数组不能为空.'] if file_name_array.nil?
        return [false, '分类规则不能为空.'] if sort_rule.nil?

        tmp = []
        tmp_hash= {}
        file_name_array.each do |file_name|
          reg = Regexp.new(sort_rule['regular'])
          res = reg.match(file_name)
          next if res.nil?
          tmp << file_name
        end 
        tmp_hash[sort_rule['zh_name']] = tmp
        [true, tmp_hash]
      end 

      # 根据更新时间对文件名称进行排序
      def sort_by_update_time(file_name_array: nil, dir_path: nil)
        return [fasle, '文件名数组不能为空'] if file_name_array.nil?
        return [fasle, '文件夹相对路径不能为空'] if dir_path.nil?

        tmp_hash = {}
        file_name_array.each do |file_name|
          res = file_update_time(file_name: file_name, dir_path: dir_path)
          tmp_hash.merge!({(res[0] ? res[1].to_i : 0) => file_name })
        end 

        file_name_array = tmp_hash.sort{|x,y| y[0] <=> x[0]}.map{|array| array[1]}
        [true, file_name_array]
      end 

      # 获取文件最后的更新时间
      def file_update_time(file_name: nil, dir_path: nil)
        return [false, '文件名不能为空'] if file_name.nil?
        return [false, '文件夹路径不能为空'] if file_name.nil?

        res = to_path(path: dir_path, is_dir: true)
        return res unless res[0]
        dir_path = res[1]

        path = File::join(dir_path, file_name)
        update_time = File::mtime(path)

        [true, update_time]
      end 

      private 

        # 针对分类结果进行排序
        def order_with_index(file_name_hash: nil)
          return [fasle, '结果集不能为空'] if file_name_hash.nil?
          key_size = file_name_hash.keys.size 
          index_array = SORT_RULES.map{|hash| hash['index']}
          default_index = ((0...key_size).to_a - index_array)[0]

          tmp_array = []
          SORT_RULES.each do |hash|
            tmp_array.insert(hash['index'], hash['zh_name'])
          end 
          tmp_array.insert(default_index, SURPLUS_FILE_CLASS_NAME)
          tmp_array = tmp_array.compact
          tmp_hash ={}
          tmp_array.each do |k|
            tmp_hash[k] = file_name_hash[k]
          end
          [true, tmp_hash]
        end 
    end 

  end 
end 