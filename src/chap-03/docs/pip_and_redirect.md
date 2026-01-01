# Chapter 03: Pipe and Redirect

## この章の目的
- パイプ `|` とリダイレクトの意味を理解する
- 一時ファイルを作らずに処理する感覚を身につける
- 標準入力・出力・エラーの違いを理解する

---

## Linuxの3つのストリーム

Linuxのコマンドは最初から3つの入出力を持つ。

| FD | 名前 | 説明 |
|---|---|---|
| 0 | stdin  | 標準入力 |
| 1 | stdout | 標準出力 |
| 2 | stderr | 標準エラー |

---

## パイプ `|`

```bash
A | B
````

* A の標準出力を B の標準入力へ渡す
* 中間結果はファイルに書かれず、メモリ上で流れる

### 例

```bash
ls | wc -l
grep "ERROR" app.log | wc -l
```

---

## 出力リダイレクト `>`

```bash
command > file.txt
```

* 標準出力（stdout）をファイルへ
* 既存ファイルは上書きされる

```bash
ls > list.txt
```

---

## 追記リダイレクト `>>`

```bash
command >> file.txt
```

* ファイルの末尾に追加

```bash
echo "first"  > log.txt
echo "second" >> log.txt
```

---

## 標準エラーのリダイレクト `2>`

```bash
command 2> error.txt
```

* 標準エラー（stderr）だけをファイルへ送る

```bash
ls not_exist.txt 2> err.log
```

---

## stdout と stderr を分ける

```bash
ls . not_exist.txt 1> out.log 2> err.log
```

* `>` は `1>` の省略形
* stdout と stderr は別ルート

---

## `/dev/null`

```bash
command > /dev/null
command > /dev/null 2>&1
```

* `/dev/null` は何を書いても捨てるデバイス
* `2>&1` は stderr を stdout と同じ行き先へ向ける
* 両方捨てたいときの定型文：

  ```bash
  command > /dev/null 2>&1
  ```

---

## リダイレクトの順番に注意

```bash
command > /dev/null 2>&1   # stdout, stderr ともに捨てる（正）
command 2>&1 > /dev/null   # stderr は画面に出る（違いあり）
```

* リダイレクトは左から順に評価される

---

## tee（分岐）

```bash
command | tee file.txt
```

* 標準出力を

  * 画面に表示しつつ
  * ファイルにも保存

```bash
sort fruits.txt | uniq -c | tee result.txt
```

### 追記

```bash
command | tee -a file.txt
```

---

## xargs とパイプの違い

```bash
find src -type f | wc -l
```

* wc は stdin を読める → xargs 不要

```bash
find src -type f | xargs grep "TODO"
```

* grep にファイル名を引数で渡したい → xargs 必要

* xargs = stdin を「引数」に変換する

---

## よくある実務パターン

### ログの ERROR を集計

```bash
grep "ERROR" app.log | sort | uniq -c | sort -nr
```

### 結果を保存

```bash
grep "ERROR" app.log | wc -l > error_count.txt
```

### 表示しながら保存

```bash
grep "ERROR" app.log | wc -l | tee error_count.txt
```

---

## この章で身についたこと

* パイプで処理をつなげられる
* stdout / stderr を制御できる
* 一時ファイルを作らずに作業できる
* tee で表示と保存を同時にできる

