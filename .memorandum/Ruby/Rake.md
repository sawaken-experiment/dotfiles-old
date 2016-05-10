# Rakefileの書き方についてのメモ書き

## タスクを定義する
```
[task|rule|file] <task_name> => <depended_task_names> do
  ...
end

<task_name> := シンボル or 文字列
<depended_task_names> := <task_name> or <task_name>の配列
```
依存タスクおよびブロックは無くてもOK.

ruleおよびfileはMakefileのサフィックスルール&差分ビルドと同じことができる.
便利だが柔軟性には劣るので, 単純なファイル生成以外に使おうとするとハマる.

```ruby
rule '*.o' => '*.c' do |t|
  sh "cc -c #{t.source} -o #{t.name}"
end
```

### タスクに別名をつける
以下で対応可能.
```ruby
task :hoge => :fuga
```

### タスクに説明文を付する
これを行うと`rake -T`でそのタスクが表示されるようになる.
```ruby
desc 'タスクAの説明'
task :a
```

### タスクの強制スキップと強制終了
* `next`でそのタスクは強制的に成功となる.
* `fail(msg_str)`でそのタスクは強制的に失敗となる.

## トップレベルの関数
* `sh(command)`
コマンドを表示した上で実行する.
結果がエラーならタスクはその時点で失敗.
* `rm(name)`, `cd(path)`等
FileUtilの関数群がデフォルトでトップレベルにextendされている模様.

## 名前空間を用いてタスクをグループ化する
```ruby
namespace :main do
  task :install => ['x', 'helper:x']
  task :x
end

namespace :helper do
  task :x
end
```

### 名前空間内のタスクのリストを取得する
```ruby
namespace(:helper){}.tasks
```

### タスクの絶対パス指定はできない模様
以下の様な構造の場合, 名前空間`test:x`内部から名前空間`x`にアクセスすることは無理っぽい.
```ruby
namespace :x do
  task :install
end

namespace :test do
  namespace :x do

  end
end
```

### 名前空間の正体
実のところ, 以下の二つは全く同じ意味を持つ模様.
```ruby
namespace 'a' do
  namespace 'b' do
    task 'c'
  end
end

task 'a:b:c'
```
