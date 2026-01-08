# Shell Script 基礎まとめ（学習用メモ）

## 1. Shebang（シバン）

```bash
#!/usr/bin/env bash
```

### 意味

* **このスクリプトをどのインタプリタで実行するか** をOSに伝える
* `env` を使うことで **環境にある bash を自動で探す**

### なぜ `/usr/bin/env bash` がよい？

* `/bin/bash` 固定よりも **移植性が高い**
* macOS / Linux / Docker 環境で安全

---

## 2. `set -euo pipefail`

```bash
set -euo pipefail
```

**安全な shell script の三種の神器**

### `-e`（errexit）

```bash
set -e
```

* **どこかでエラーが起きたら即終了**
* エラーを見逃さない

```bash
cp not_exist.txt /tmp
echo "ここは実行されない"
```

---

### `-u`（nounset）

```bash
set -u
```

* **未定義変数を使うとエラー**
* タイポ検出に非常に有効

```bash
echo "$foo"   # foo が未定義 → エラー
```

---

### `-o pipefail`

```bash
set -o pipefail
```

* パイプラインの **途中で失敗しても検知**
* デフォルトでは最後のコマンドの終了コードしか見ない

```bash
false | true
echo $?   # pipefail なし → 0 / あり → 1
```

---

## 3. 変数の基本

### 代入

```bash
x=10
name="Alice"
```

⚠️ **= の前後にスペースを入れない**

```bash
x = 10   # ❌ エラー
```

---

### 参照（展開）

```bash
echo "$x"
echo "${name}"
```

* **参照するときは `$` をつける**
* 文字列中では `"${var}"` が安全

---

### なぜ代入時は `$` がいらない？

```bash
x=5        # 代入（変数名）
echo "$x"  # 展開（中身）
```

👉

* **左辺：変数名**
* **右辺：値**

---

## 4. 算術展開

### `$(( ))`（算術展開）

```bash
x=3
y=$((x + 1))
```

* 中では `$` を省略できる
* C言語ライクな書き方

---

### `(( ))`（算術コマンド）

```bash
((y = x + 1))
```

* 計算結果を変数に代入
* **終了ステータスを返す**（条件式にも使える）

```bash
if ((x > 0)); then
    echo "positive"
fi
```

👉

```bash
y=$((x + 1))
((y = x + 1))
```

**結果は同じ**だが用途が少し違う

---

## 5. 引数の扱い

### `$1`, `$2`, `$@`, `$#`

```bash
echo "$1"   # 第1引数
echo "$@"   # 全引数（配列的）
echo "$#"   # 引数の数
```

---

### デフォルト値付き展開

```bash
n="${1:-5}"
```

意味：

* `$1` があればそれ
* なければ `5`

```bash
./script.sh     # n=5
./script.sh 10  # n=10
```

---

## 6. for 文

### 引数をすべて処理

```bash
for f in "$@"; do
    echo "$f"
done
```

* `"$@"` は **必ずクォート**
* スペースを含む引数を安全に扱える

---

## 7. 条件分岐（if）

### ファイル判定

```bash
if [[ "$f" == *.txt ]]; then
    echo "text file"
elif [[ "$f" == *.log ]]; then
    echo "log file"
else
    echo "other"
fi
```

### `[[ ]]` を使う理由

* `[` より安全
* glob / 正規表現が使える
* クォート忘れに強い

---

## 8. while 文

### 基本形

```bash
while condition; do
    処理
done
```

### 数値条件

```bash
i=1
while ((i <= 5)); do
    echo "$i"
    ((i++))
done
```

---

## 9. よく使うテンプレート

```bash
#!/usr/bin/env bash
set -euo pipefail

for f in "$@"; do
    if [[ "$f" == *.txt ]]; then
        echo "txt: $f"
    elif [[ "$f" == *.log ]]; then
        echo "log: $f"
    else
        echo "other: $f"
    fi
done
```

---

## 10. まとめ（重要ポイント）

* **shebang + set -euo pipefail は基本セット**
* 代入時は `$` 不要、参照時は `$` 必須
* 算術は `$(( ))` / `(( ))`
* `"$@"` は必ずクォート
* `[[ ]]` を使う

---

