# Elmのテストツール

公式サイトのパッケージ紹介ページ(<http://package.elm-lang.org/packages>)を見ると、テストツールっぽいものが４つほど存在する。

* TheSeamau5/elm-check - Property-based testing in Elm
* avh4/elm-spec - Experimental alternative for writing unit tests
* deadfoxygrandpa/Elm-Test - Unit Testing Support with Element/String outputs
* joefiorini/elm-time-machine - elm-time-machine Tests

それぞれとりあえず調べてみる。

# 1. elm-check
Property-based testingを行うためのツール。

使い方は<http://package.elm-lang.org/packages/TheSeamau5/elm-check/3.2.0>を見れば全部載ってる。
以下はそれの要約っぽいもの。

Property-based testingってのはよく分からないけどホーア論理っぽいテスト手法。以下の様な感じ。

* 人間が書く部分 = テスト対象のプログラムと、そのプログラムが満たすべき入力の条件(性質)と出力の条件(性質)
* ツールの仕事 = 条件を満たす入力をランダムでいくつかプログラムに与え、出力が条件を満たすかチェックする

unit-testingでは人間が頭の中で出力が満たすべき性質を考えて、その性質を満たすかチェックするための具体例(テストケース)を記述する。

property-based-testingでは出力が満たすべき性質を直接記述する。

自動テストの主流であるunit-testingの問題をelm-checkでは以下の様に解決しているらしい。

1. assertionを書くのがだるい => unit-testを自動生成する
2. テストケースを考えるのに、テスト対象のプログラムに対する深い理解が要求される => テストケースはランダムで色々試す
3. ユニットテストが失敗しても原因が分かりづらい => 最小の失敗ケースを計算して表示してくれる

1はまぁわかる。書き方や使用するテストツールにもよるけど、だるいし時間かかる。

2もわかるけど、これによってテストを書いてる最中にバグに気付いたりするので、利点でもある。

3はよく分からないけどテスト結果の出力が丁寧とかそんなレベルの話かな。

## 1.1 使い方

```elm
List.reverse : List a -> List a
```
をテストしてみる。

まず出力が満たすべき性質`claim`を適当に考える。

1. 任意のlistにreverseを二回適用したら元に戻る
2. 任意のlistにreverseを適用しても、listの長さは変わらない


実際には以下の様に書ける
```elm
claim_reverse_twice_yields_original : Claim
claim_reverse_twice_yields_original =
  claim
    "Reversing a list twice yields the original list"
  `that`
    (\list -> reverse (reverse list))
  `is`
    (identity)
  `for`
    list int

claim_reverse_does_not_modify_length : Claim
claim_reverse_does_not_modify_length =
  claim
    "Reversing a list does not modify its length"
  `that`
    (\list -> length (reverse list))
  `is`
    (\list -> length list)
  `for`
    list int
```
DSLの文法は<http://package.elm-lang.org/packages/TheSeamau5/elm-check/3.2.0/Check>の下の方に書いてあるので頑張って読む。

`list int`の部分は入力の条件を指定する式で、`investigator`と呼ぶらしい。
書き方は<http://package.elm-lang.org/packages/TheSeamau5/elm-check/3.2.0/Check-Investigator>を頑張って読む。

`claim`は`suite`関数で纏められる。
```elm
suite_reverse : Claim
suite_reverse =
  suite "List Reverse Suite"
    [ claim_reverse_twice_yields_original
    , claim_reverse_does_not_modify_length
    ]
```

`claim`は`quickCheck`関数で実行できる。
```elm
result : Result
result = quickCheck suite_reverse
```

`result`は`display`関数で表示できる。
```elm
main = display result
```

## 1.2 その他
deadfoxygrandpa/Elm-Testを組み込めるらしい。

<http://package.elm-lang.org/packages/TheSeamau5/elm-check/3.2.0>の下の方に書いてある。

# 2. elm-spec
deadfoxygrandpa/Elm-Testの拡張らしい。
spec流の記述が出来るunit-testingツール。

<http://package.elm-lang.org/packages/avh4/elm-spec/1.0.0>

上記ページのサンプルを動かそうと試みるも、エラーが出るので断念。
```sh
$ elm-make Main.elm
Error when searching for modules imported by module 'Main':
    Could not find module 'IO.IO'

Potential problems could be:
  * Misspelled the module name
  * Need to add a source directory or new dependency to elm-package.json
```

# 3. Elm-Test
多分これが一番有名。オーソドックスなunit-testing.

ドキュメントページ<http://package.elm-lang.org/packages/deadfoxygrandpa/Elm-Test/1.0.4>
のサンプルコード見るだけで使い方が分かってしまう。

ただし、サンプルコードのelmは少し古いので、import文にexposingキーワードを書き足してGraphics.Elementを明示的にimportする必要がある。

```elm
-- Example.elm
import String

import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Assertion exposing (assert, assertEqual)
import ElmTest.Runner.Element exposing (runDisplay)
import Graphics.Element exposing (..)

import LispParser as LP

tests : Test
tests = suite "A Test Suite"
        [ test "Addition" (assertEqual (3 + 7) 10)
        , test "String.left" (assertEqual "a" (String.left 1 "abcdefg"))
        , test "This test should fail" (assert False)
        ]

main : Element
main = runDisplay tests
```

# 4 elm-time-machine
実行時の状態を巻き戻せる「タイム・トラベリング・デバッガー」として使えるツール(たぶん)。

Elm 0.15には対応してないらしいので触ってみてない。

<http://package.elm-lang.org/packages/joefiorini/elm-time-machine/1.0.0>
