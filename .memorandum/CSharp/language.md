# C# language memo


# 属性
```csharp
class Hoge {
  [Conditional("DEBUG")]
  public void hoge() {
    System.Console.WriteLine("hogee");
  }
}
```

クラスだったりメソッドだったりメソッドのパラメーターだったりを定義する際に、System.Attribute型の値を任意個、メタ情報としてプログラム要素にセットすることができる。
基本的にはただのメタ情報なので、リフレクション等で明示的に取り出さない限り、セットしただけでは何も起きない。
ただし、ConditionalAttributeなど、コンパイラが参照する特別な組み込み型もある。

属性をセットする部分は、どうやら特殊なシンタックスのようである。
```
属性指定 := [属性型名(constructor-arg*, named-arg*), ...]

属性型名は、クラス名がHogeAttributeである場合はHogeのみでもよい
constructor-arg := 属性型のコンストラクタ引数
named-arg := 属性型に含まれるpublicなフィールド名=値
```
適用例

```csharp
using System;

[AttributeUsage(AttributeTargets.All)]
public class MyAttribute : Attribute {
  public int a, b;
  public MyAttribute(int a) {
    this.a = a;
  }
}

class Hoge {
  [My(123, b = 456)]
  public void hoge() {
    System.Console.WriteLine("hogee");
  }
}
```

属性とは何かについては<https://msdn.microsoft.com/ja-jp/library/z0w1kczw.aspx>に書いてある。

属性を自作する方法は<https://msdn.microsoft.com/ja-jp/library/sw480ze8.aspx>に書いてある。

属性の詳細については<http://smdn.jp/programming/netfx/attributes/>が参考になった。
