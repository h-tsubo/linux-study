
# Chapter 01: Shell Basics

## 目的
- Linux のシェル操作に慣れる
- コマンドを「意味」で理解する
- 検索に頼らず基本操作ができるようになる

---

## カレントディレクトリと移動

### pwd
```bash
pwd
````

* print working directory
* 今いるディレクトリを表示する

### cd

```bash
cd /workspace
cd ..
cd -
```

* cd = change directory
* `..` は親ディレクトリ
* `-` は直前にいた場所

---

## ls コマンド

### 基本

```bash
ls
```

* ls = list
* 現在のディレクトリの中身を表示

### 詳細表示

```bash
ls -la
```

* `-l` = long（詳細表示）
* `-a` = all（隠しファイルも含めて表示）
* `ls -la` と `ls -al` は同じ意味

---

## ファイル・ディレクトリ操作

### mkdir

```bash
mkdir test
mkdir -p a/b/c
```

* mkdir = make directory
* `-p` は途中のディレクトリもまとめて作る

### touch

```bash
touch a.txt
```

* ファイルがなければ作成
* あれば更新時刻を変更

### rm / rmdir

```bash
rm a.txt
rmdir test
```

* rm = remove
* rmdir は「空のディレクトリのみ削除できる（安全）」

---

## コマンドの連結

### 危険な例

```bash
mkdir test; cd test
```

* `;` は成功・失敗に関係なく次を実行
* mkdir が失敗しても cd が実行される

### 安全な例

```bash
mkdir test && cd test
```

* `&&` は成功した場合のみ次を実行

---

## Tab 補完

* Tab 1回：補完できれば補完
* Tab 2回：候補を一覧表示
* 記憶ではなく補完を使うのが Linux 流

---

## less の役割

```bash
ls --help | less
```

* 出力をページ送りで表示
* スクロール・検索が可能
* 人間が読むときは最後に less

---

## ディレクトリ構造の理解

* `/` はルートディレクトリ
* `/root` は root ユーザーのホーム
* `/workspace` は `/` の直下にある別ディレクトリ
* `ls -a` は「今いる場所」しか表示しない

---

## 学んだことまとめ

* シェルはコマンド実行環境
* コマンド名は英語の省略形
* 状態が変わる操作では `&&` を使う
* Tab 補完と履歴検索は必須スキル

````
