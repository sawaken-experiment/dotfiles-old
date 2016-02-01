# ASP.NET Webform 基本用語

## プロジェクト
プロジェクト。最大単位。
Web.config(アプリケーション構成ファイル)が最も根本的な設定ファイル。

## ページ(ASP.NETページ、Webフォーム)
そのままページ。hoge.aspxファイル。
VSではデザインビュー/ソースビュー切り替えて編集できる。

## サーバコントロール(コントロール)
ページに置かれる要素。ボタンとか。
手打ちするか、VSのツールボックスからD&D。

## プロパティ
ページ上のサーバコントロールに個別に与える設定値。
ページ上のサーバコントロールタグのアトリビュートとして記入する。
VSではフォーカスがアクティブな要素のプロパティがプロパティウィンドウに表示されるので、そこから編集してもよい。

## ビルド、リビルド、クリーン
順に「前回ビルドからの変更点のみビルド」「前回ビルドを破棄してビルド」「前回ビルドを破棄」

## ASP.NET Webアプリケーション、ASP.NET Webサイト
前者はビルドしてからデプロイする。後者はデプロイ先でビルドされる。(?)
ASP.NET Webサイトの方が新しい。古い方のASP.NET Webアプリケーションを使っとけば問題ないらしい。

## アプリケーションフォルダー(予約フォルダー)
デフォルトでは、HTTP経由でアクセスできない。
* App_*
* Bin

## ファイルの種類
* .ascx - ユーザコントロール
* .master - マスターページ(ページの共通要素)
* .sitemap - サイトマップ情報
* .mdf - SQL Server データベース
* Global.asax - 初期化/終了処理
* Webconfig - アプリケーション構成ファイル

## コードビハインドモデル(分離コードモデル) (=>コードインラインモデル)
hoge.aspx.csを分離コードと呼ぶ。

## ディレクティブ
```
<%@ ディレクティブ名 属性目="属性値"...%>
```

## コード宣言ブロック
```
<script runat="Server">
...
</script>
```

## サーバコントロール
```
<asp:コントロール名 ID="ID値" runat="Server" プロパティ名="値" ...></asp:コントロール名>
```

<form runat="Server"></form>の中に記述する。<form>タグはページ内に一回しか出現できない。

* コントロールツリー
```
Pageオブジェクト
|- Formオブジェクト
   |- LiteralControlオブジェクト
   |- Controlオブジェクト
```

* ページインスペクター - コントロール<=>htmlの分析ツール。

## イベントドリブンモデル
* Postback - イベント処理のために、サーバにリクエストを送ること。Page.IsPostBackで確認できる。
* サーバーラウンドトリップ - イベント効果のために、サーバクライアント間で処理を行き来すること。
* 各種ページイベントは、Postbackであろうとなかろうと常に発生する。
* 変更系イベントは、それ単体ではPostbackされない(AutoPostBackプロパティで有効にもできる)。クリック系のイベントなどが発生した際に、それまでの変更系イベントとまとめてPostbackされる。Postbackされたイベントのサーバでの処理順は、変更系イベント->クリックイベント。

## ビューステート
* コントローラにセットしたデータは、Postback時には自動でビューステートに保存されることにより、Postback後にも維持される。
そのため、ページが読み込まれる度に(たとえば、Page_Loadイベントハンドラ内で)コントローラにデータをセットする必要は無い。
* 変更系イベントハンドラがバインドされている場合、変更前の値もサーバ側で必要になる(イベントオブジェクトとして渡される?)ので、ビューステートとして保存される。
* データ量が大きくなると、ビューステートとしてデータを持ちまわすのは重くなる。コントロールに対して、ViewStateModeプロパティを設定することで、ビューステートのON/OFFが設定できる。


# 様々なコントロール

## フォームコントロール
* TextBox
    * TextModeプロパティに(SingleLine, MultiLine, Password, Color, Date, DateTime, DateTimeLocal, Email, Month, Number, Range, Search, Phone, Time, Url, Week)を設定。
    * その他の主なプロパティ(Columns, MaxLength, ReadOnly, Rows, Text, Wrap)
* RadioButtonList
    * Selectedプロパティで選択済みに。
    * グループ化されない単一のRadioButtonを設置したい場合はRadioButtonコントロールが使える。
    * その他の主なプロパティ(RepeatLayout=Table|Flow|OrderedList|UnorderedList, RepeatDirection=Horizontal|Vertical, RepeatColumns, CellPadding, CellSpacing, TextAlign=Left|Right)
* CheckBoxList
    * 複数選択が可能な点を除き、RadioButtonListと同じ。単一の場合はCheckBoxコントロール。主なプロパティは(Checked, Text, TextAlign)
* DropDownList
    * 見た目以外はRadioButtonListと同じ。
* ListBox
    * リストボックス。SelectionMode=Multiple|Singleプロパティで複数選択可不可を指定。Rowsで行数指定。
* FileUpload
```csharp
if (upload_cont.HasFile) {
  upload_cont.PostedFile.SaveAs("~/hoge");
}
```
* HiddenField


### List系コントロールのプロパティアクセスの例
```csharp
list.SelectedValue <=> list.SelectedItem.Value <=> (for item in list.Items where item.Selected select item).First().Value
list.SelectedIndex <=> list.Select((item, idx) => new {Index = index, Item = item}).Where(i => i.Item.Selected).Select(i => i.Index)
```

## 表示系コントロール
* Label/Literal
    * Labelはspanタグにくるまれて出力。Literalはそのまま出力。
* HyperLink
    * aタグあるいはaタグでくるまれたimgタグを生成。clickイベントは発生しない。
    * 主なプロパティは、(ImageUrl, NavigateUrl, Target=\_blank|\_parent|\_search|\_self|\_top, Text)。ImageUrlかTextのどっちかは必須。
* Image
    * imgタグを生成。
    * 主なプロパティは、(AlternateText, DescriptionUrl, GenerateEmptyAlternateText, ImageAlign, ImageUrl).
    * HTMLの作法として、Altは必ず書こう(装飾画像の場合、Altは空文字列にする)。

## ボタンコントロール
* Button/LinkButon/ImageButton
    * 基本プロパティ = Text, OnClientClick, PostBackUrl, ImageAlign, ImageUrl
    * コマンドプロパティ = CommandArgument, CommandName
    * 検証プロパティ = CausesValidation, ValidationGroup

## 検証コントロール
ASP.NET 4.5以降では、「プロジェクトにjQueryをインストール」「jQueryをアプリケーションに登録」する必要がある。(p104)

* RequiredFieldValidator
    * InitialValueプロパティに設定された値と等しい場合は×。InitialValueプロパティのデフォルト値は空文字列。
* RangeValidator
    * MaximumValue, MinimumValue, Type=String|Integer|Double|Date|Currency
    * 範囲検証不可能な入力が与えられた場合はスキップする(エラーを生じない)ので、CompareValidatorと併用するべき。
* CompareValidator
    * コントロール同士の比較、特定の値との比較、大小関係比較、データ型に当てはまるかどうかの検証。
    * Operator=DataTypeCheck|Equal|GreaterThan|GreaterThanEqual|LessThan|LessThanEqual|NotEqual
    * Type=String|Integer|Double|Date|Currency
    * ValueToCompare=比較する値
    * ControlToCompare=比較するコントロールのID
* RegularExpressionValidator (p121)
    * ValidationExpression="マッチすべき正規表現"。(定型的なパターンは正規表現エディターから入力できる。)
* CustomValidator
    * プロパティではなくServerValidateイベントに対するイベントハンドラとして検証コードを記述する。
    * クライアントサイドでも検証を行う場合は、ClientValidationFunction="JSの関数名"。
* ValidationSummary
    * 他の検証コントロールのエラーメッセージを一挙に表示するためのコントロール。
    * DisplayMode=BulletList|Lis|SingleParagraph, HeaderText, ShowMessageBox=True|False,  ShowSummary=True|False,

### 検証コントロールの共通プロパティ
* ControlToValidate[必須] ="コントロールID"
* EnableClientScript =True|False
* Enabled =True|False
* SetFocusOnError =True|False
* ValidationGroup ="検証グループ名"
    * コントロールに検証グループ名を設定する。
    * 検証グループが設定された要素が生じさせたイベントによりPostbackが発生した場合、同じ検証グループに属する検証コントロールだけが実行される。
    (ちなみに、CausesValidation=Falseが設定された要素が生じさせたイベントによるPostbackでは、如何なるvalidationも実行されない。)
* CssClass ="クラス名"
    * コントロール自身の表示領域に付加するクラス名。
* Display =None|Static|Dynamic
    * Staticの場合、あらかじめエラーメッセージの表示領域をページに用意しておく。
    * Noneの場合はエラーメッセージを表示しない。ValidationSummaryコントロールによって別途表示したい場合など。
* ErrorMessage[必須] ="エラーメッセージ"
    * ValidationSummaryに引き渡すための、エラーメッセージ。
* Text ="エラーメッセージ"
    * (Displayで設定される)コントロール自身の表示領域に表示するエラーメッセージ。省略された場合はErrorMessageの値が使われる。
* IsValide[読み取り専用] =True|False
```csharp
validation_cont.IsValid
Page.IsValid
```

# データバインドコントロール
データがバインドされるサーバコントロールのこと。
* GridView - 表(テーブル)形式。
    * [GridViewタスク]->[データソースの選択]でデータソース構成ウィザードが始まるので、[DBの接続先を選択/作成]する。(接続構成の詳細についてはp158も参照)
    [Selectステートメントの構成]において、[詳細設定]から、INSERT,UPDATE,DELETEステートメントの生成をチェック。
    * その後、[GridViewタスク]から[ページングを有効にする]、[並べ替えを有効にする]、[編集を有効にする]などを設定できる。
    * デフォルトでは列はBoundFieldクラスとして置かれているので、必要に応じて列を変更/追加する。利用可能なXxxFieldクラスとプロパティはp161
* DetailsView -
* FormView -
* ListView - 自由形式のリスト
などがある。

## データソースコントロール
データソースとデータバインドコントロールの仲介役。
* SqlDataSource - RDBからデータを取ってくる。
* SiteMapDataSource - サイトマップファイルから
* XmlDataSource - XMLファイルから
* ObjectDataSource - 任意のオブジェクトから
* LinqDataSource - LINQ式を評価することによって(?)
* EntityDataSource - Entityから
