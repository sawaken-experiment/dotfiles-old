# TypeScript 型まわりメモ
* \*付き => 値型のみ (≒singleton)
* \+付き => 変数型のみ(≒abstract)
## 基本型
```
+any
  string
    *null, *undefined
  number
    *null, *undefined
  boolean
    *null, *undefined
  enum
    *null, *undefined
  ?"hoge" (String Literal型)
    *null, *undefined
  void
    (*null, *undefined)
```

### any型用例
```ts
// 等価 (aはany型の変数として宣言される)
var a;
var a : any;
// 等価ではない (前者はstring型の変数として宣言される)
var s = "hoge";
var s : any = "hoge";
```

### enum型用例
```ts
enum Color { Red, Black }
var col : Color = Color.Red
```

### String Literal型用例
```ts

```

### void型用例
```ts
function f(i : number) : void {
  alert(i);
}
```

## オブジェクト型
```ts
myClass
{a: string} (Object Literal型)
typename[] (Array型)
インターフェース型
関数定義型
モジュール定義型
```

#


```
