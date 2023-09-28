https://www.runoob.com/w3cnote/yaml-intro.html

https://www.redhat.com/sysadmin/yaml-beginners

https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html

# 官方网站-纯YAML格式网站

https://yaml.org/

\#： 注释

开头三个-,结尾三个.

大小写敏感

无tab，只有空格; 用空格表示缩进、层级关系

左对齐，表示同一层级

回车+缩进

若YAML元素不是纯量（scalars），是另一种数据类型，需要；若是纯量，那么就按标准格式：

# 跨行-(缩进将被忽略）(是否带换行）

```YAML
# Literal Block Scalar: include newlines + trailing spaces
include_newline: |
  exactly as you see
  will appear these three
  lines of poetry

# Folded Block Scalar: fold newlines to spaces; apply to long long line;
fold_newlines: >
  this is really a
  single line of text
  despite appearances
  
## 强制换行
## 1. 两次回车；2. 回车+缩进； 3. 缩进+回车； 4. \n
flod_some_newline: >
  a
  b

  c
  d
    e
  f

fold_same_newline: "a b\nc d\n e\nf\n"
```

# 对象-键值对的集合

```YAML
# 键值对的标准格式：冒号+空格
key: value

key: {key1: value2, Key2: value2}
key: 
    child-key1: value1
    child-key2: value2

# 把所有keys看成一个数组[key1, key2], 把所有的values也看出一个数组[value1, value2]
? 
    - key1
    - key2
: 
    - value1
    - value2
```

# 数组-一组有序的值

```YAML
# 值的标准格式： 以-开头

- A
- B
- C

key: [value1, value2]

- 
    - A
    - B
    - C
    

# flow式： companies: [{id: 1, name: alibaba, price: 200W}, {id: 2, name: tecent, price: 500W}]
companies: 
    - 
        id: 1
        name: alibaba
        price: 200W
    - 
        id: 2
        name: tecent
        price: 500W
```

# 复合结构: 数组+对象

```YAML
lang: 
    - Ruby
    - Perl
    - Python
websites: 
    YAML: 'yaml.org'
    Ruby: 'ruby-lang.org'
    Python: 'python.org'
    Perl: 'use.perl.org

# 转换为JSON
{
    lang: [Ruby, Perl, Python]
    websites: {
        YAML: 'yaml.org',
        Ruby: 'ruby-lang.org',
        Python: 'python.org',
        Perl: 'use.perl.org
    }
}
```

# 标量

```YAML
boolean: 
    - TRUE
    - True
    - true    # 推荐
    - FALSE
    - False
    - false    # 推荐
float: 
    - 3.14
    - 6.8523015E+5
int:
    - 123
    - 0b1010_0111_0100_1010_1110
null: 
    nodeName: 'node'
    parent: ~
string: 
    - 哈哈
    - 'hello world'  # 单引号VS双引号：双引号种可以使用转义符（\n,\t，\\)
    - "hello world"  # 引号可以消除特殊符号的作用：[] {} > | * & ! % # ` @ ,？：-
    - newline
      newlin2  # 字符串被拆成多行，每一行会被转化成要给空格
date: 
    - 2018-02-17 # ISO 8601  即yyyy-MM-dd
datetime:
    - 2018-02-17T15:02:31+08:00 # ISO 8601 T:附加时间（Time），+附加时区
```

# 别名

```YAML
# 创建别名：&
# 应用别名：*
# 合并至此：<<

default: &defaults
    adapter: postgres
    host: localhost
    
development: 
    database: myapp_development
    <<: *defaults
    
test: 
    database: myapp_test
    <<: *defaults
    
# 以上，相当于
default: &defaults
    adapter: postgres
    host: localhost
    
development: 
    database: myapp_development
    adapter: postgres
    host: localhost
    
test: 
    database: myapp_test
    adapter: postgres
    host: localhost
    
# 再举一个例子
- &showell Steve
- Clark
- Brian
- Oren
- *showell

# 转化为JS
['Steve', 'Clark', 'Brian', 'Oren', 'Steve']
```