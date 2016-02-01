# TypeScript 文法メモ


## 変数型の宣言
```ts
var str : string;
var str : string = "hoge";
```

## 多相な変数型の宣言

## 型推論

## オブジェクトのメンバー
```
プロパティ
呼び出しシグネチャ(call operator overload)
コンストラクタシグネチャ(new operator overload)
インデックスシグネチャ([] operator overload)
```

## 関数定義に関する構文糖
```ts
// option, default, rest

// arrow (thisはstaticに解決される)
// ブロック内が単一式の場合は{}とreturnを省略可
// 引数が一つで型注釈無しならば()も省略可
(x : number, y : number) : number => {
  return x + y;
}
```

## スコープ
