
# Chapter 02: Find / Grep / Count / Aggregate

## この章の目的
- ファイルが多くても迷わない
- 「探す・絞る・数える・まとめる」をコマンドで行う
- ls だけに頼らない実務的な操作に慣れる

---

## 基本方針（Linux的考え方）
- ls：構造を把握する
- find：対象を集める
- grep：中身で絞る
- wc：数える
- sort / uniq：整理・集計する

---

## ls（一覧・確認）

```bash
ls
ls -la
ls -lah
````

* ls = list
* -l = long（詳細）
* -a = all（隠しファイル含む）
* -h = human readable（人間向けサイズ）

---

## find（場所で探す）

### 基本形

```bash
find <path> <condition>
```

### ファイルだけ探す

```bash
find . -type f
```

### ディレクトリだけ

```bash
find . -type d
```

### 拡張子で探す

```bash
find . -type f -name "*.txt"
```

※ `*` はシェル展開を防ぐためクォートが必要

---

## find の主なオプション

### 深さを制限

```bash
find . -maxdepth 2 -type f
```

### 更新時刻で探す（分）

```bash
find . -type f -mmin -60
```

* m = modification
* min = minutes
* `-60` = 60分以内

---

## grep（中身で探す）

```bash
grep "ERROR" file.txt
```

### よく使うオプション

```bash
grep -n "ERROR" file.txt   # 行番号付き
grep -i "error" file.txt   # 大文字小文字無視
grep -r "ERROR" .          # 再帰検索
```

* -n = number（行番号）

---

## wc（数える）

```bash
wc -l file.txt
```

* wc = word count
* -l = line

### find と組み合わせる

```bash
find . -type f | wc -l
```

---

## sort / uniq（整理・集計）

### 基本パターン

```bash
sort file.txt | uniq -c
```

* sort：並べる（uniq の前提）
* uniq -c：重複を数える

### 多い順に並べる

```bash
sort file.txt | uniq -c | sort -nr
```

* -n = numeric
* -r = reverse

---

## 拡張子ごとの件数を数える（棚卸し）

```bash
find . -type f -name "*.*" \
  | sed 's/.*\.//' \
  | sort \
  | uniq -c \
  | sort -nr
```

やっていること：

1. ファイル一覧取得
2. 拡張子だけ抽出
3. 並べ替え
4. 件数集計
5. 多い順に表示

---

## grep × 集計（実務例）

### TODO の件数を調べる

```bash
grep "TODO" src/*.txt | wc -l
```

### TODO 内容ごとに集計

```bash
grep "TODO" src/*.txt | sort | uniq -c | sort -nr
```

---

## xargs（引数に変換）

```bash
find . -name "*.log" | xargs grep "ERROR"
```

* xargs = eXtended ARGuments
* 標準入力を「コマンドの引数」に変換する

---

## 重要な概念まとめ

* find は「場所」
* grep は「中身」
* wc は「数」
* sort / uniq は「整理」
* パイプで小さな道具をつなぐ

---

## この章でできるようになったこと

* ファイル構造の把握
* 条件付き検索
* ログ・TODO の集計
* 拡張子ごとの棚卸し

---

## 次章へのつながり

* パイプ `|`
* リダイレクト `>` `>>`
* 標準入力 / 出力 / エラー

→ Chapter 03 へ
