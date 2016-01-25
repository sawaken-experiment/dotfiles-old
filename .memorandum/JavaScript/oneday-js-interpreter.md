# すごい勢いでJSインタプリタを作りたい
飽きる前に終わらせたい。

## 実装言語
オブジェクトがそのまま使えると嬉しい気がするので、実装言語にもJSを使うのが良さそう。

オブジェクトがラップされていないものならばAltJSでも問題なさそうなので、CofeeScriptをチョイスしてみる。

## 構文解析
面倒なのでサードパーティーのライブラリにやってもらう。

* [esprima](https://github.com/jquery/esprima)

<http://esprima.org/demo/parse.html>で試せる。すごい。

## サポートする範囲
さすがにECMAScript5を全部実装するなんてことはしない。

1. プロトタイプチェーン
2. this
3. new

あたりが実装できればそれでよい。

### サポートするデータ型

1. プリミティブなnumber
2. プリミティブなstring
3. function
4. object

1, 2に「プリミティブな」と付けているからには「プリミティブでないnumber」はサポートしないということである。

すなわち、以下はランタイムエラーとする。
```js
1.toString()
```
ちなみにJSではfunctionもobjectの一種なので、functionは()で呼び出せる特殊なobjectということになる。

### サポートするプリミティブ演算
基底となる処理は組み込みで用意しておかなければならない。

各種プリミティブ演算のトリッキーな挙動こそがJSの悪名の原因だったりするので、
JSマニアになりたい場合は真剣に実装した方がいいかもしれない。

今回はそんな気力はないので最低限のものだけざっくり実装する。

1. 四則演算子
2. ==演算子
3. display関数 (引数に与えたnumberあるいはstringを表示する)


### サポートする構文

「プロトタイプチェーン」「this」「new」を実装して動かしてみる上での最低限。

1. if文
2. 変数宣言文「var hoge」の形のみ(var hoge, fugaやvar hoge = 1はダメ)
3. 代入式
4. function式「function(args){...}」の形のみ
5. this式
6. new式

## 実装方針
変数環境(ENV)と抽象構文木(AST)を引数に取って、ENVを評価してくれる関数を作りたい。
```ts
eval : (ENV, AST) => ENV
```
ENVはJSのオブジェクトで表現する。

esprimaがパース結果のASTをJSのオブジェクトとして吐いてくれるので、ASTについてはそれをそのまま使う。

### ENVの実装方針
delete文などはサポートしないので極シンプル。
```ts
Eget : (ENV, string) => any
Eset : (ENV, string, any) => any
Edec : (ENV, string) => void
Egen : Env => Env
```

### オブジェクトの実装方針
```ts
Oget : (object, string) => any
Oset : (object, string, any) => any
```
プロトタイプの設定はOsetを通して行う。
Ogetはプロトタイプチェーンも考慮した解決を行う。

### thisの実装方針
global変数としてスタックを持つ。

A.Bの形をした式を評価する際に以下の様にスタックを操作すると、スタックのトップにあるオブジェクトが現在のthisの値となる。
```
Aを評価 => スタックにAを評価した結果をpush => Bを評価 => スタックをpop
```
evalの引数に渡すような形にして純粋にしてもよいが、面倒なのでglobalに持つ。

また、new A(B, C)を評価する際には、
```
Aを評価(評価結果をaとする) => B, Cを評価(評価結果をb, cとする) => aをプロトタイプに持つ空のオブジェクトをスタックにpush => a(b, c)を評価 => スタックをpop(popした値を返す)
```

```ts
Tpush : object => void
Tpop : void => object
Ttop : void => object
```

### evalの実装方針
末尾再起最適化などを行うわけではないので、普通に再帰的にeval関数を定義する。
```ts
function eval(env : ENV, node : AST) : any {

}
```

## 実装コード

## 動作確認

## 今回スルーした要素
