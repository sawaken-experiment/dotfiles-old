# View tips

# 参考書
ASP.NET MVC5 実践プログラミング

# ディレクトリ構成

Controllerに合わせるのが基本。

Controllers/HogeController.cs内のHogeController#Hello()に対応するViewファイルは、Views/Hoge/Hello.cshtml。

# Razorの文法

hoge.cshtmlファイルを記述する文法。

## コードナゲット(インライン式) @Name
* HTMLエンコードされる(たとえば、<は＆lt;に変換される)
* @を表示したいときは@@でエスケープ

## コードブロック @{文*}
* if, switch等は@if(～){～}と書ける
* @:で一行復帰
* &lt;hoge>～&lt;/hoge>で複数行復帰 (特例として、hoge=textとすると、&lt;text>タグ自体は出力されない)

## サーバコメント@_*～_*@
* コメントアウト
* 何処でも使える

## 匿名型オブジェクトでタグの属性を指定したりする時
* C#の予約語は属性名に使えないので、先頭に@を付ける(C#では識別子のプレフィックスとして@が使える！)

# ビュー変数
```csharp
ViewBag.hoge = "hogeee";
ViewData["fuga"] = "fugaa";
```

```razor
<p>@ViewBag.hoge</p>
<p>@ViewData["fuga"]</p>
```

# モデルのデータを自動で良い感じにフォームとして表示したい

テンプレートヘルパー(DisplayFor, EditorFor)を使う。
モデルのプロパティの型とメタ情報(属性)から、適切な表示方法を選んで表示してくれる。

※ヘルパーメソッドの末尾に付いているForは、モデルと連携することを意味する。

モデルのプロパティの型と、プロパティに付加した属性を元に、適切なフォーマットでDisplay表示/Editor表示してくれる。

「ヘルパーメソッド呼び出し時の指定 -> UIHint属性 -> DataType属性 -> データ型」の優先順で表示形式を決定するので、UIHint属性を利用することで強制的にテンプレートを指定することも可能。

## 独自のテンプレートでモデルのデータを表示

独自のテンプレートを作成して、以下のいずれかの場所に保存すればよい。
* ~/Views/Shared/(Display|Editor)Templates/Xxx.cshtml (グローバル)
* ~/Views/コントローラ名/(Display|Editor)Templates/Xxx.cshtml (コントローラローカル)

[UIHint("Hoge")]ならHoge.cshtml,

[DataType(DataType.Date)]ならDate.cshtml,

Fuga型のプロパティならFuga.cshtmlが上記の場所から自動で探索される。

独自のテンプレートの作り方については、たとえばFuga.cshtmlを以下の様に作る
```razor
@model Fuga

<p>@model.message</p>
```

ヘルパーメソッド呼び出し時に与えたデータを独自テンプレート内で使用するような構造も作れるらしい(参考書p126)。

## モデルをまるごと自動で良い感じに表示したい
ヘルパーメソッドDisplayForModelとEditorForModelでできるらしい

参考書p128

# モデルのデータをマニュアルでフォームの要素として表示したい

上の場合が上手くいかないときなど。あんまり使わないかな？

* LabelFor
* TextBoxFor
* TextAreaFor
* PasswordFor
* HiddenFor
* RadioButtonFor
* CheckBoxFor
* DropDownListFor
* EnumDropDownListFor
* ListBoxFor

参考書p101

# フォーム要素を生成したい

モデルに関係なく、単にフォーム関連の要素を生成したいとき。

* BeginForm (BeginRouteForm)
* Label
* TextBox
* TextArea
* Password
* Hidden
* RadioButton
* CheckBox
* DropDownList
* ListBox

参考書p99(BeginForm), p111

# リンクを生成したい

URLは~/hoge/の形式にすると、自動でアプリケーションルートからの絶対パスに変換される。

* ActionLink (RouteLink)

参考書p112。

# ビューへルパーの自作
参考書p130。

# レイアウト(共通テンプレート)の自作
ページの外枠を共有するための仕組みがレイアウトである。

レイアウトのテンプレートファイルは先頭に_を付けのが慣習。

どのレイアウトを使うかの指定は、テンプレートにおいて、以下の様に指定する。(レイアウトを使用しない場合はnullをセット)
```razor
@ {
  Layout = "レイアウトファイルのパス";
}
```

全ての非レイアウトテンプレートは、自動的にViews/\_ViewStart.cshtmlをインクルードする。
ここにLayoutのデフォルト設定が書かれている。
```razor
@ {
  Layout = "~/Views/Shared/_Layout.cshtml";
}
```

コントローラから指定してやることも可。

## レイアウトの書き方
RenderBodyメソッドで、メインコンテンツの位置を指定。ここにページ毎のテンプレートが埋め込まれる形となる。
同様に、サブコンテンツの位置を指定することもできる。そのサブコンテンツが必須かどうかも指定する。

例えば、レイアウトファイルに以下の様に書く。
```razor
@RenderSection("hoge", required: false)
```

そして、このレイアウトを利用するテンプレートに以下の様に書けば、レイアウトファイルの指定の場所にサブコンテンツが埋め込まれる。
```razor
@section hoge {
  <div>hoge!</div>
}
```

レイアウトテンプレート内においてLayout = "レイアウトファイルのパス";と記述することにより、レイアウトを入れ子にすることが可能である。

参考書p144.

# 部分ビュー
ページのコンテンツを共有するための仕組みが部分ビューである。

部分ビュー自体の書き方は普通のビューテンプレートと同じ。
ファイル名はレイアウトと同様に_から始め、以下のいずれかの場所に保存する。
* ~/Views/コントローラ名/\_HogePartial.cshtml
* ~/Views/Shared/\_HogePartial.cshtml

部分ビューをインクルードするには、以下の様に書く。
```razor
@Html.Partial("_HogePartial", Model)
```

子アクションを作って呼び出す方式も可(部分ビューが、親ビューが持たない固有のデータを必要とする場合に用いる方式)。

子アクションの定義
```csharp
[ChildActionOnly]
public ActionResult Hoge() {
  return PartialView("_HogePartial", "hoge!");
}
```

部分ビューの定義
```razor
@model string
<p>@model</p>
```

部分ビューの呼び出し
```razor
@Html.Action("Hoge", "ControllerName")
```

参考書p153

# ビューエンジンの変更/自作
デフォルトのRazorを使っておけば問題ない。

参考書p160。

# モバイル対応
Hoge.cshtmlに対し、Hoge.Mobile.cshtmlを作成すれば、自動でモバイルアクセス時にはHoge.Mobile.cshtmlが使われる。
レイアウトに関しても同様。

さらに細かい振り分けを行う場合は、たとえばHoge.iPhone.cshtmlなどを作成し、Global.asax.csに判定コードを追加する(参考書p174)。
