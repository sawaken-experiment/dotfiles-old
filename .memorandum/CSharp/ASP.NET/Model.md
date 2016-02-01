# Model tips

# ASP.NET MVC + Entity Frameworkによるモデル定義 (コードファースト編)

以下はコードファースト(エンティティを元にDBテーブルを生成する)手順。

* データモデル(エンティティ)の定義 - テーブルの行に相当する、POCOなクラス。テーブルの個数だけ作る。ただし、中間テーブルに対応する分は必要ない。
* コンテキストの定義 - アプリケーションが使用するテーブル(エンティティ)群を列挙しておくクラス。一個だけでよい。
* DB接続情報を設定 - DBサーバーとの接続情報と、コンテキストファイルの場所を設定する。Web.configに書く。参考書p52.
* イニシャライザの定義 - DBを初期化するタイミングと、初期化の際に挿入する初期データを定義する。無くてもよい。

以下、<>で囲った部分はDBの定義と対応する。

データモデル(エンティティ)の定義
```csharp
// Models/<テーブル名>.cs
using System;

namespace MvcBasic.Models {
  public class <テーブル名> {
    public <DBのカラム型に対応したC#の型名> <カラム名> { get; set; }
    ...
  }
}
```

コンテキストの定義
```csharp
// Models/任意の名前(MvcBasicContextとか).cs
using System.Data.Entity;

namespace MvcBasic.Models {
  public class 任意の名前(MvcBasicContextとか) : DbContext {
    public DbSet<<テーブル名=エンティティクラス名>> <テーブル名=エンティティクラス名>s { get; set; }
    ...
  }
}
```

イニシャライザの定義
```csharp
///Models/任意の名前(MvcBasicInitializerとか).cs
using System;
using System.Data.Entity;

namespace MvcBasic.Models {
  public class 任意の名前(MvcBasicInitializerとか) : イニシャライザーの基底クラス {
    protected override void Seed(コンテキストクラス名 context) {
      context.<テーブル名>s.Add(new <テーブル名> { ～ });
      context.SaveChanges();
    }
  }
}
```

```
イニシャライザーの基底クラス := CreateDatabaseIfNotExists<コンテキストクラス名>
                         | DropCreateDatabaseAlways<コンテキストクラス名>
                         | DropCreateDatabaseIfModelChanges<コンテキストクラス名>
```

イニシャライザを登録する
```csharp
// Global.asax.cs
using MvcBasic.Models;
using System.Data.Entity;
...
protected void Application_Start() {
  ...
  Database.SetInitializer<コンテキストクラス名>(new イニシャライザクラス名());
}
```

## テーブル同士の関係を表現する <=> エンティティ同士の関係を表現する

* 1:nの関係

例えば、Article:Comment (コメントはそれぞれ一つの記事に対して書かれる)。
DBとしてはCommentテーブルの各データがArticle_idを持つことによって関係が表現される。
ArticleエンティティがCommentsプロパティを持ち、CommentエンティティがArticleプロパティを持てば、良きに計らってくれる。
```csharp
// virtual付けないと駄目らしい。
public virtual ICollection<Comment> Comments { get; set; }
public virtual Article Article { get; set; }
```

* m:nの関係

例えば、Article:Author (一つの記事を複数の著者が書いているかもしれない)。
DBとしては中間テーブル(Article_id, Author_id)を用いて関係が表現される。
ArticleエンティティがAuthorsプロパティを持ち、AuthorエンティティがArticlesプロパティを持てば、良きに計らってくれる。
```csharp
public virtual ICollection<Author> Authors { get; set; }
public virtual ICollection<Article> Articles { get; set; }
```

いずれとも、外部キーは自動で生成される。しかし、明示的に定義しておいた方が都合が良いらしい。
```csharp
public int ArticleId { get; set; }
public virtual Article Article { get; set; }
```

「Articleプロパティが利用する外部キーのプロパティ = ArticleIdプロパティ」であることは、名前から勝手に判断されるらしい……。
実際のDB定義で変な名前(推論不可能な名前)を使いたい場合は、以下の様にすればよい。
```csharp
[Column("hennaName_art_id")]
public int ArticleId { get; set; }
public virtual Article Article { get; set; }
```

## テーブルの各列に制約を付ける <=> エンティティの各プロパティに属性(規約)を付ける

```csharp
[Table("Hoge")] // エンティティクラスに対し、実際のDB定義でのテーブル名を明示的に指定。
[Column("HogeCol", Order=0, TypeName="NTEXT")] // プロパティに対し、実際のDB定義でのカラム定義を明示的に姉弟。
[key] // プロパティに対し、主キーであることを指定。
[Required] // プロパティに対し、 not nullを指定。
[MaxLength(30)] // プロパティに対し、データ長(VARCHAR(N)のN)を指定。
[NotMapped] // プロパティを、実際のDB定義にマッピングしないよう指定。
[Index] // プロパティのIndex化を指定。
```

* 複合型
```csharp
[ComplexType]
public class Name {
  public string FirstName { get; set; }
  [Column("LastName")]
  public string LastName { get; set; }
}

public class Person {
  public int Id { get; set; }
  // Nameプロパティの代わりに、Name_FirstNameプロパティとLastNameプロパティが定義される。
  public Name Name { get; set; }
}
```

* Fluent APIを用いて、プロパティの規約をコンテキスト側から指定する
エンティティをシンプルに保ちたいため。参考書p191。

## 接続名を変更する(デフォルトでは、コンテキストクラス名 = 接続名)
```csharp
// コンテキストクラスのコンストラクタ
public MvcModelContext() : base("MyName") {}
```

# ASP.NET MVC + Entity Frameworkによるモデル定義 (データベースファースト編)
以下はデータベースファースト(既存のDBテーブルを元にエンティティを生成する)手順。

テーブル定義を用意した後にGUIをポチポチするだけ。

MS SQL Serverの場合は<https://msdn.microsoft.com/ja-jp/data/jj206878.aspx>の通りで出来ると思われる。

MySQLの場合も<http://nugetmusthaves.com/Package/MySql.Data.Entity>のプラグインを入れるだけで同じように出来る…だったら嬉しい。

# マイグレーション
エンティティを変更したら、それに応じてDBスキーマも変更されてほしい…。という願いをかなえる機能。
イニシャライザは単なる初期化(テーブル内のデータは全て消える)なので、趣旨が違う。

デフォルトでは無効になっている。

参考書p194.

# LINQでデータを探索する
テーブル内のデータに、リストプログラミングのノリでアクセスする。
特に難しいことはない。とりあえず参考書p205.

# ASP.NET MVC + Entity Frameworkで定義したモデルを操作する
モデル定義後にScaffoldingでCRUDを自動生成したコードが参考になる。

* Create - 参考書p76

```csharp
[HttpPost]
[ValidateAntiForgeryToken] // CSRF対策。リクエスト元のURLをチェック。
public ActionResult Create([Bind(Include = "Id,Name,Email,Birth,Memo")] Member member) {
  if (ModelState.IsValid) {
    db.Members.Add(member);
    db.SaveChanges();
    return RedirectToAction("Index");
  }
}
```

* Read

```csharp
Member memver = db.Members.Find(id);
```

* Update - 参考書p83

```csharp
db.Entry(member).State = EntityState.Modified;
db.SaveChanges();
```

* delete - 参考書p86

```csharp
Member member = db.Members.Find(id);
db.Members.Remove(member);
db.SaveChanges();
```

コントローラからデータにアクセスする
```csharp
using MvcBasic.Models;
...
public class HogeController : Controller {
  private コンテキストクラス名 db = new コンテキストクラス名();
  ...
  public ActionResult Show() {
    return View(db.<テーブル名>s);
  }
}
```


## 関連を持ったエンティティの操作

* Create - 直感的。以下のいずれかでArticleプロパティを設定してやればよい。
    * Article = new Article {...}
    * Article = 既存のArticleオブジェクト
    * ArticleId = 既存のArticleId
* Read - 直感的。Comment.Article。
* Update - 直感的。Createと同様にArticleプロパティを変更してやればよい。
* Delete - 謎の挙動。Articleを削除する場合、まずどこかでArticle.Commentsにアクセスし、関連するコメントを読み込まなくてはならない。その後は以下の通り。
    * Comment.ArticleIdがnullableならCommentは削除されない。Comment.ArticleIdの値はnullとなる。
    * Comment.ArticleIdがnot nullableなら、Commentも一緒に削除される。

## 内部的に発行されたSQL命令をログ出力する方法
dbインスタンスに対して以下のように設定する。
```csharp
db.Database.Log = sql => {
  System.Diagnostics.Debug.Write(sql);  
};
```

## SQL文を直接実行する
SqlQueryメソッドおよびExecuteSqlCommandメソッドを利用する。参考書p232.

## トランザクション
SaveChangesメソッドおよびExecuteSqlCommandメソッドは全ての変更が成功しない限りロールバックするので、明示的にトランザクションを設ける必要は無い。
SaveChangesメソッドとExecuteSqlCommandメソッドを併用するような場合は明示的にトランザクション範囲を指定してやる必要がある。参考書p235

## 同時実行制御
テーブルの同一行を複数人が同時にupdateしてしまう状況をできれば回避したいとき。
エンティティにTimestampプロパティを定義する手法がサポートされている。参考書p236.

## 排他制御
普通に「ExecuteSqlCommandメソッドでテーブルをロック -> 排他的な処理を実行 -> ExecuteSqlCommandメソッドでロック解除」でやればいいのかな。

SQLからテーブルをロックするクエリは<http://dev.mysql.com/doc/refman/5.7/en/lock-tables.html>など。

# 入力値の検証
モデルのプロパティに属性(アノテーション)を定義することによって実現する。

* [クライアントサイド/サーバサイド] 単純な検証(文字列の長さの検証など)参考書p240.
* [クライアントサイド/サーバサイド] 他の要素と一致しているかの検証(Compare検証)参考書p249.
* [サーバサイド] 検証関数をバインドすることによる独自検証(他の要素も参照できる)参考書p252.

属性(アノテーション)から自作することもできる。何でもできるし便利だが、作るのに手間はかかる(参考書p256)。
