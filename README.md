<!-- TOC -->

- [1. 规范](#1-规范)
  - [1.1. 返回值规范](#11-返回值规范)
  - [1.2. 关于默认值](#12-关于默认值)
    - [1.2.1. nil](#121-nil)
- [2. API](#2-api)
  - [2.1. FileBase](#21-filebase)
    - [2.1.1. exist](#211-exist)
    - [2.1.2. size](#212-size)
    - [2.1.3. common_file](#213-common_file)
    - [2.1.4. to_path](#214-to_path)
  - [2.2. Directory](#22-directory)
    - [2.2.1. each_dir](#221-each_dir)
    - [2.2.2. sort_file](#222-sort_file)
    - [2.2.3. file_update_time](#223-file_update_time)
    - [2.2.4. dir_files](#224-dir_files)
  - [Goddess](#goddess)
    - [cat](#cat)

<!-- /TOC -->

# 1. 规范

## 1.1. 返回值规范
调用API的返回结果格式为: `[布尔值, 结果]`<br>
布尔值用来表示调用是否成功.<br>
调用未成功时,如果失败不可逆,将返回失败原因.<br>
若可逆,如文件过大情况,将返回与 *Linux错误代码* 保持一致的错误代码.<br>
可针对该错误代码制定具体的解决措施.

## 1.2. 关于默认值

### 1.2.1. nil

参数说明中默认值为 `nil` 表明该参数为必填参数.

# 2. API

## 2.1. FileBase
FileBase为Cat_File中其他类的基类,子类继承后将获得的方法有:

### 2.1.1. exist

> exist
>> 方法类型: 类方法<br>
>> 功能说明<br>
>> 检查path参数是否存在.

参数|类型|默认值|说明
-|-|-|-
path|字符串|`nil`|文件/文件夹在项目目录下的相对路径

```ruby
path = File::split(Rails.root.join('log')).join('/')
CatFile::FileBase.exist(path: path)
#=> [true, ""] 

path = File::split(Rails.root.join('no_way')).join('/')
CatFile::FileBase.exist(path: path)
#=> [false, "该路径不存在"] 
```

### 2.1.2. size

> 方法名
>> 方法类型: 类方法<br>
>> 功能说明<br>
>> 检查path路径的文件大小

参数|类型|默认值|说明
-|-|-|-
path|字符串|`nil`|文件/文件夹在项目目录下的相对路径
routine_check|布尔|true|是否进行基础检查:<br>参数path是否为nil.<br>调用 `#exit`方法对文件及文件夹是否存在进行检查

```ruby
path = File::split(Rails.root.join('log')).join('/')
CatFile::FileBase.size(path: path)
#=> [true, 4096] 
```

### 2.1.3. common_file

> 方法名
>> 方法类型: 类方法<br>
>> 功能说明<br>
>> 检查path是否为普通文件

参数|类型|默认值|说明
-|-|-|-
path|字符串|`nil`|文件/文件夹在项目目录下的相对路径
routine_check|布尔|true|是否进行基础检查:<br>参数path是否为nil.<br>调用 `#exit`方法对文件及文件夹是否存在进行检查

```ruby
path = File::split(Rails.root.join('log')).join('/')
CatFile::FileBase.common_file(path: path)
#=> [false, "该路径文件为:'目录',非普通文件."]
```

### 2.1.4. to_path

> to_path
>> 方法类型: 类方法<br>
>> 功能说明<br>
>> 获取文件或文件夹的绝对路径

参数|类型|默认值|说明
-|-|-|-
path|字符串|`nil`|文件/文件夹在项目目录下的相对路径
is_exist|布尔|true|是否检查该路径下的文件或文件夹是否存在
is_dir|布尔|false|path参数是否为文件夹
is_common_file|布尔|!is_dir|当path参数非文件夹时,<br>是否检查文件为普通文件,<br>如果文件非普通文件将返回其具体类型.
check_size|布尔|true|是否检查文件或文件夹大小
file_size|数字|3072|当path参数非文件夹时,是否检查文件大小.<br>文件大小超出默认值时,返回 `[false, "EFBIG"]`

```ruby
CatFile::FileBase.to_path(path: 'log', is_dir: true)
=> [true, "/home/xxx/cat_file/test/dummy/log"]
```







## 2.2. Directory

Directory主要处理引擎中关于目录迭代,文件排序等工作.

### 2.2.1. each_dir

> each_dir
>> 方法类型: 类方法<br>
>> 功能说明<br>
>> 返回路径下文件夹内文件名称的数组集合.

参数|类型|默认值|说明
-|-|-|-
path|字符串|'log'|文件夹在项目目录下的相对路径
show_hide_file|布尔|false|是否返回文件夹内的隐藏文件
time_sort|布尔|true|是否根据最后更新时间进行排序(倒序)

```ruby
CatFile::Directory.each_dir
#=> [true, ["orders_exception_2018_08_24.log", "brands_exception_2018_08_23.log", "emalls_exception_2018_08_21.log"]]
```

> sort_by_update_time
>> 方法类型: 类方法<br>
>> 功能说明<br>
>> 根据更新时间对文件名称进行排序

参数|类型|默认值|说明
-|-|-|-
file_name_array|数组|`nil`|文件夹内文件名称的数组集合
dir_path|字符串|`nil`|文件夹相对路径

```ruby
CatFile::Directory.sort_by_update_time(
  file_name_array: 
    ["emalls_exception_2018_08_21.log", "orders_exception_2018_08_24.log"], 
  dir_path: 'log'
)
#=> [true, ["orders_exception_2018_08_24.log", "emalls_exception_2018_08_21.log"]]
```
### 2.2.2. sort_file

> sort_file
>> 方法类型: 类方法<br>
>> 功能说明<br>
>> 对文件名的数组集合进行分类

参数|类型|默认值|说明
-|-|-|-
file_name_array|数组|`nil`|文件夹内文件名称的数组集合
sort_rule|散列|nil|分类规则,如:<br>{"regular"=>"([a-zA-Z0-9]+Interface\|[a-zA-Z0-9]+_log_p)", "zh_name"=>"电商接口日志", "index"=>2}<br>参数说明:<br>regular: 根据文件名进行分类的正则表达式规则<br>zh_name: 分类下文件的键(分类的中文名称)<br>index: 在所有分类中的排序下标.

```ruby
file_name_array = [
  'orders_exception_2018_08_24.log', 'LeadingInterface_log_p_20180827.log'
]
sort_rules=[
  {"regular"=>"([a-zA-Z0-9]+Interface|[a-zA-Z0-9]+_log_p)", "zh_name"=>"电商接口日志", "index"=>2},
  {"regular"=>"[a-z_]+exception", "zh_name"=>"类异常日志", "index"=>0}
]

tmp_hash = {}
sort_rules.each do |sort_rule|
  res = CatFile::Directory.sort_file(file_name_array: file_name_array, sort_rule: sort_rule)
  return res unless res[0]
  tmp_hash.merge!(res[1])
end 
tmp_hash
#=> {"电商接口日志"=>["LeadingInterface_log_p_20180827.log"], "类异常日志"=>["orders_exception_2018_08_24.log"]} 
```

### 2.2.3. file_update_time
> file_update_time
>> 方法类型: 类方法<br>
>> 功能说明<br>
>> 获取文件最后的更新时间

参数|类型|默认值|说明
-|-|-|-
file_name|字符串|`nil`|文件名称
dir_path|字符串|`nil`|文件所在文件夹的相对路径

```ruby
CatFile::Directory.file_update_time(file_name: "LeadingInterface_log_p_20180827.log", dir_path: 'log')
#=> [true, 2018-08-27 17:18:56 +0800] 
```

### 2.2.4. dir_files

> dir_files
>> 方法类型: 类方法<br>
>> 功能说明<br>
>> 获取文件夹内文件名称分类集合,集成了上述Directory类下其他公开方法的调用

参数|类型|默认值|说明
-|-|-|-
path|字符串|`nil`|文件夹在项目目录下的相对路径
show_hide_file|布尔|false|是否展示以`.`开头的隐藏文件
sort_file_name|布尔|true|是否根据分类规则对文件名进行分类
sort_rules|数组|nil|分类规则(哈希)的数组集合

```ruby
CatFile::Directory.dir_files
#=> [true, {"类异常日志"=>[], "电商接口日志"=>[], "其他文件"=>[]}]
```

## Goddess

### cat
> cat
>> 方法类型: 类方法<br>
>> 功能说明<br>
>> 获取具体文件内容

参数|类型|默认值|说明
-|-|-|-
path|字符串|`nil`|文件/文件夹在项目目录下的相对路径
check_size|布尔|true|是否检查文件或文件夹大小

```ruby
CatFile::Goddess.cat(path: "log/#{params[:file_name]}", check_size: false)
#=> [true, ["# Logfile created on 2018-08-24 18:30:38 by logger.rb/56438\nI",...]]
```

<hr>

> 模板

> 方法名
>> 方法类型: 实例方法|类方法<br>
>> 功能说明<br>
>> 描述

参数|类型|默认值|说明
-|-|-|-
path|字符串|`nil`|文件/文件夹在项目目录下的相对路径

```ruby

```