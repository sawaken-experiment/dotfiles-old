# Git Basics

## commit
コミットとは、以下の３つの情報を持つ、変更不可能なタプルである。
* 一意なID(コミット番号)
* 親コミットへの参照(1つあるいは2つ)
* 親コミットに対する変更情報

## branch
ブランチとは、以下の２つの情報を持つ、変更可能なタプルである。
* 一意な名前(ブランチ名)
* あるコミットへの参照

## current branch (HEAD)
現在のブランチとは、以下の１つの情報を持つ、変更可能なタプルである。
* あるブランチへの参照

## remote repository (の名前付け)
リモートリポジトリとは、以下の２つの情報を持つ、変更可能なタプルである。
* リモートリポジトリ名
* リモートリポジトリURL

# Git Commands

## git remote
```
git remote
git remote add <name> <url>
git remote rm <name>
git remote rename <old-name> <new-name>
```

## git push
```
git push <remote> <branch=レポジトリとローカルの双方に存在する全てのブランチ>

remote = local.getRemoteByName(<remote>)
bl = local.getBranchByName(<branch>)
br = remote.getBranchByName(<branch>)
```
* blがbrにとってfast-forward(早送り)の位置ならば、br.ref = bl.ref
* そうでないならば、エラーを表示して何もしない。

## git fetch
```
git fetch <remote> <branch=全てのブランチ>
```
* local.setBranchByName(remote.getBranchByName(<branch>), "remotes/#{rn}/#{bn}")
* 現在のブランチに対応するフェッチブランチは、`FETCH_HEAD`で参照できる。

## git merge
```
git merge <branch>

b = HEAD
tb = local.getBranchByName(<branch>)
```
* tbがbにとってfast-forwardならば、fast-forward-mergeを行う。b.ref = tb.ref
* そうでないならば、3way-mergeを行う。b.ref = newcommit(b, tb, ~)
* ~の部分が自動で解決できない場合は、stageが特殊な状態に移行する。
この状態においては、conflictしたファイルを編集することによって手動で全てのconflictを解決し、編集内容をコミットする必要がある。
全てのconflictを解決しない限り、コミットは行えない。
`git reset --hard`などによって、`git merge`を実行する前のstageの状態に戻すことができる。

## git pull
```
git pull <remote> =
  git fetch <remote>
  git merge FETCH_HEAD

git pull --rebase <remote>  
```

## git checkout
```
git checkout
```
`HEAD`
