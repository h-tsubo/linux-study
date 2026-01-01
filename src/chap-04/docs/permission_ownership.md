# Chapter 04: Permission and Ownership

## この章の目的
- `ls -l` の表示を意味で読めるようになる
- `chmod` / `chown` / `chgrp` を正しく使えるようになる
- Permission denied を自力で原因切り分けできるようになる

---

## Linuxの権限モデル（全体像）

Linuxのファイル権限は次の3点で決まる。

```text
誰が / 何を / どこまでできるか
````

---

## ls -l の読み方

```bash
ls -l
```

例：

```text
-rwxr-xr--
```

---

### 1. 先頭1文字（ファイルの種類）

| 文字  | 意味        |
| --- | --------- |
| `-` | 通常ファイル    |
| `d` | ディレクトリ    |
| `l` | シンボリックリンク |
| `c` | キャラクタデバイス |
| `b` | ブロックデバイス  |

---

### 2. 残り9文字（権限）

```text
rwx r-x r--
```

| 対象     | 説明   |
| ------ | ---- |
| user   | 所有者  |
| group  | グループ |
| others | その他  |

---

### 3. 権限文字の意味

| 文字 | 意味          |
| -- | ----------- |
| r  | read（読む）    |
| w  | write（書く）   |
| x  | execute（実行） |

---

## ファイルとディレクトリの違い（重要）

### ファイルの場合

| 権限 | できること |
| -- | ----- |
| r  | 中身を読む |
| w  | 中身を変更 |
| x  | 実行    |

---

### ディレクトリの場合（超重要）

| 権限 | できること    |
| -- | -------- |
| r  | 中身一覧を見る  |
| w  | 作成・削除    |
| x  | 中に入る（cd） |

※ ディレクトリは **x がないと中に入れない**

---

## chmod（権限変更）

### 数値指定

| 権限 | 数値 |
| -- | -- |
| r  | 4  |
| w  | 2  |
| x  | 1  |

```bash
chmod 755 script.sh
```

```text
rwx r-x r-x
```

---

### 記号指定

```bash
chmod u+x file.sh
chmod g-w file.txt
chmod o+r file.txt
```

| 記号 | 意味     |
| -- | ------ |
| u  | user   |
| g  | group  |
| o  | others |
| a  | all    |

---

## 実行できない理由（典型）

```bash
./script.sh
```

```text
Permission denied
```

原因チェック：

* 実行権限（x）があるか
* 実行方法が正しいか（`./`）
* 所有者・グループは適切か

---

## chmod 777 が危険な理由

```bash
chmod 777 file.txt
```

* 誰でも
* 読める / 書ける / 実行できる

→ セキュリティ事故の原因

---

## 所有者とグループ

```bash
ls -l
```

```text
-rwxr-xr-- root root file.txt
```

---

### chown（所有者変更）

```bash
chown user file.txt
chown user:group file.txt
```

* 指定するのは `/etc/passwd` の **1列目（ユーザー名）**
* 実行できるのは root のみ

---

### chgrp（グループ変更）

```bash
chgrp group file.txt
```

* 指定するのは `/etc/group` の **1列目（グループ名）**

---

## ユーザー・グループの確認

```bash
id
getent passwd
getent group
```

* `id`：自分の身元
* `getent passwd`：ユーザー一覧
* `getent group`：グループ一覧

---

## 実務でよく使う権限パターン

| 用途      | 権限        |
| ------- | --------- |
| 実行スクリプト | 755       |
| 設定ファイル  | 644       |
| 秘密鍵     | 600       |
| ディレクトリ  | 755 / 700 |

---

## Permission denied の切り分け手順

1. `ls -l` で権限を見る
2. x があるか確認
3. 所有者・グループを確認
4. 必要なら `chmod` / `chown`

---

## この章で身についたこと

* rwx の意味を説明できる
* chmod を数値・記号で使える
* chown / chgrp の指定対象が分かる
* Permission denied を自力で直せる

---

## 次章へのつながり

* プロセスとジョブ管理
* ps / top / kill
* バックグラウンド実行
