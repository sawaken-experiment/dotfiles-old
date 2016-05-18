.script
=======




## メモの管理
`.memorandum/`以下にMarkdown形式のメモファイルを置く.
`.script`以下の`m`, `mo`, `mc`コマンドを用いて全文検索ができる.

実行例:
```sh
$ m com tar # ['com', 'tar']でメモを検索
$ mo com tar # ['com', 'tar']でメモを検索し、該当ファイルを編集
$ mc Hoge Fuga # .memorandum/Hoge/Fuga.mdを編集
```
