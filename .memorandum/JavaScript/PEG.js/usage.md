# PEG.js

[official documentation](http://pegjs.org/documentation#generating-a-parser-command-line)

# use by pre-compile for web browser (or node.js)
```
$ npm install pegjs
$ pegjs -e parser mylanguage.pegjs mylanguage-syntax.js

<script src="mylanguage-syntax.js"></script>
<script>
var parsed = parser.parse("1 + 1");
console.log(parsed); # => 2
</script>
```

# use by dynamic-compile (for node.js)
```
$ npm install pegjs

var PEG = require("pegjs");
var parser = PEG.buildParser(mylanguage_syntax_string);
var parsed = parser.parse("1 + 1");
console.log(parsed); # => 2
```

# how to write mylanguage.pegjs
Parsing Expression Grammar (PEG) に基づく。

# toplevel
```
(<rulename> = <exp>)+
```
一番最初のrulenameが開始点となる。

# primitive
```
"hoge"   - トークンhoge
.        - 任意の文字
[abc]    - aかbかc
rulename - rulenameを再帰的にパース
(exp)    - expと同じ
```

# repeat
* `exp *` - 0回以上
* `exp +` - 1回以上
* `exp ?` - 1回or0回。0回ならnull

全てbacktrackingをしないことに注意。
例えば以下のパーサは如何なる入力も受理しない。
```
start = ("a"*) "a"
```

# guard
* `& exp` - restがexpとしてパース可能なら何も読み取らずに続行。そうでないなら失敗。
* `! exp` - restがexpとしてパース不可能なら何も読み取らずに続行。そうでないなら失敗。
* `& { return xxx; }` - xxxが真なら何も読み取らずに続行。そうでないなら失敗。
* `! { return xxx; }` - xxxが偽なら何も読み取らずに続行。そうでないなら失敗。

`{}`の中では以下のものが使える。
* 先行するlabel名
* 現在位置のオブジェクトを返す関数location()
* パーサを参照するparser変数とオプションを参照するoptions変数

location()関数が返すのは以下の様なオブジェクト。
```
{
  start: { offset: 23, line: 5, column: 6 },
  end:   { offset: 23, line: 5, column: 6 }
}
```

# conversion
* `$ exp` - expをパースし、parsedとしてexpにマッチした文字列を返す
* `label:exp` - expをパースし、parsedに名前labelを付ける
* `exp1 exp2 ...` - exp1とexp2をパースし、parsedとして配列を返す
* `exp1 / exp2 / ...` - exp1 or exp2
* `exp { return xxx; }` expをパースし、parsedとしてxxxを返す

`{}`の中では以下のものが使える。
* 先行するlabel名
* 現在位置のオブジェクトを返す関数location()
* expにマッチした文字列を返す関数text()
* パーサを参照するparser変数とオプションを参照するoptions変数
* パース結果を失敗にするexpected(desc_str)関数
* 致命的な例外を投げるerr(err_msg)関数

expected(desc_str)ではbacktrackingが起こらないことに注意。
例えば以下に`ahoge`を与えたらパース結果は失敗となる。
```
start = "a" { expected("non-a"); } / [a-z]+
```
