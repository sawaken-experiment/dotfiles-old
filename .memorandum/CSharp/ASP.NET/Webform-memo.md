# GridViewの各行にボタンを設置し、クリックでその行のデータの詳細画面に遷移する。
ボタンを表示する列の定義はButtonFieldクラス。
CommandNameに適当な名前を定義しておく。

GridViewに対し、RowCommandイベントハンドラを設定することによってクリックイベントを補足する。
どの行のボタンがクリックされたのかは<http://stackoverflow.com/questions/6027251/get-data-from-rowcommand>のようにして取得する。

イベントハンドラ内で詳細画面にリダイレクトする。IDはクエリとして渡してしまい、詳細画面側でRequest.QueryString["id"]などとして取得。
idからDBを検索し、データを取り出して表示する処理は、手動バインディングでなんとかする。
