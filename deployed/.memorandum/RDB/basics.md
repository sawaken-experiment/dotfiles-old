# リレーショナル代数演算
チョイスも定義もテキトウ。

## 和 union
```haskell
union :: Tuple a => [a] -> [a] -> [a]
union t0 t1 = List.uniq (t0 ++ t1)
```

## 差 difference
```haskell
diff :: Tuple a => [a] -> [a] -> [a]
diff t0 t1 = List.reject (\e -> List.include t1 e) t0
```

## 積 intersection
```haskell
inter :: Tuple a => [a] -> [a] -> [a]
inter t0 t1 = List.select (\e -> List.include t1 e) t0
```

## 直積 cartesian product
```haskell
cproduct :: (Tuple a, Tuple b) => [a] -> [b] -> [(a, b)]
cproduct t0 t1 = [(x, y) | x <- t0, y <- t1]
```

## 射影 projection
```haskell
project :: (Tuple a, Tuple b) => [a] -> (a -> b) -> [b]
project t0 p = map p t0
```

## 選択 selection
```haskell
select :: Tuple a => [a] -> (a -> Bool) -> [a]
select t0 p = List.select p t0
```

## 結合 join
```haskell
join :: (Tuple a, Tuple b) => [a] -> [b] -> (a -> b -> Bool) -> [(a, b)]
join t0 t1 p = [(x, y) | x <- t0, y <- t1, p x y]

cproduct t0 t1 = join t0 t1 (\_ _ -> True)
```

# E-Rモデル (Entity-Relationship)
実体(entity)データと、それらの関係を定義するモデル。
実体はnode, 関係はedge(vertex). 実体同士が関係する数はcardinality = the number of vertices.

# テーブル同士の関係

## 1:1関係
A型がB型への参照を必ず1つ持ち、B型がA型への参照を必ず1つ持つ状態。

## 1:n関係
A型がB型への参照を必ず1つ持ち、B型がA型への参照を任意個持つ状態。
A型がB型への参照を持つことによって表現される。

## n:m関係
A型がB型への参照を任意個持ち、B型がA型への参照を任意個持つ状態。
A型とB型の関係は中間テーブルとして表現される。

# 正規化
[別ファイル](./normalization.md)

# トランザクション
ACID属性

* Atomicity - 原始性。全か無か。トランザクションは、全てを行うか、何も行わないかのどちらか。
* Consistency - 一貫性。「データに矛盾が無い状態で、トランザクション実行しても、データに矛盾が無い状態を維持する」ことの保証。
* Isolation - 独立性。スレッドセーフであること。
* Durability - 耐久性。どのタイミングで障害が発生したとしても、「あるトランザクションが完了している => そのトランザクションによる変更は失われない」ことの保障。

## 独立性レベル

ACIDの独立性を満たすためには当然、以下の3つを満たす必要があるが、パフォーマンス向上のために、満たさないことを許すという選択肢もある。

* dirty read - 未コミットの変更(すなわちダーティな値)を他のトランザクションが読み込む。
* non-repeatable read - あるトランザクションが読みだした行が、そのトランザクションが完了する前に、他のトランザクションによって変更される。トランザクション中にREADした個々のデータの不変性が保障されないということ。
(トランザクション内におけるREADは再現性があるべきなのにそれがないから、non-repeatable read。)
* phantom read - トランザクション中に行う条件検索(select～where)の再現性が保障されないということ。

選択肢は以下の４つ。
* READ UNCOMMITED - どれも発生しても問題ないですよ、という指定。
* READ COMMITED - ノンリピータブルリードとファントムは発生しても問題ないですよ、という指定。
* REPEATABLE READ - ファントムリードは発生しても問題ないですよ、という指定。
* SERIALIZABLE - どれも発生したらまずいので、全てきちんとチェックしてください、という指定。デフォルト。
