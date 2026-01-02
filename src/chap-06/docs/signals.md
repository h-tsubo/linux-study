# 第6章 シグナル完全理解（signals.md）

## この章のゴール
- シグナルとは何かを説明できる
- Ctrl操作・kill・bg/fg の正体を理解する
- 実務で「どのシグナルを使うべきか」を判断できる
- kill -9 を使ってよい状況・ダメな状況を区別できる

---

## 1. シグナルとは何か

### 定義
> **シグナルとは、OS がプロセスに送る「非同期の通知」**

- 割り込み
- 停止
- 終了
- 再開

などを伝えるための仕組み。

---

## 2. シグナルはどこから送られるか

### キーボード
| 操作 | シグナル |
|---|---|
| Ctrl+C | SIGINT |
| Ctrl+Z | SIGTSTP |
| Ctrl+\ | SIGQUIT |

### コマンド
```bash
kill PID
kill -9 PID
````

### OS内部

* 子プロセス終了
* I/Oエラー
* メモリ違反 など

---

## 3. 覚えておくべき重要シグナル一覧

### 最重要（必須）

| 番号 | シグナル    | 英語の由来         | 意味     | 操作方法                           |
| -: | ------- | ------------- | ------ | ------------------------------ |
|  2 | SIGINT  | Interrupt     | 割り込み   | Ctrl+C / `kill -INT PID`       |
| 15 | SIGTERM | Terminate     | 通常終了   | `kill PID` / `kill -TERM PID`  |
|  9 | SIGKILL | Kill          | 強制終了   | `kill -9 PID`                  |
| 20 | SIGTSTP | Terminal SToP | 端末から停止 | Ctrl+Z / `kill -TSTP PID`      |
| 19 | SIGSTOP | Stop          | 強制停止   | `kill -STOP PID`               |
| 18 | SIGCONT | Continue      | 再開     | `bg` / `fg` / `kill -CONT PID` |

---

### よく見るが補助的

| 番号 | シグナル    | 英語の由来                  | 意味         |
| -: | ------- | ---------------------- | ---------- |
|  1 | SIGHUP  | Hang UP                | 端末切断・再読込   |
|  3 | SIGQUIT | Quit                   | 強制終了＋コアダンプ |
| 13 | SIGPIPE | Pipe                   | パイプ破断      |
| 14 | SIGALRM | Alarm                  | タイマー通知     |
| 17 | SIGCHLD | Child                  | 子プロセス終了    |
| 11 | SIGSEGV | Segmentation Violation | メモリ違反      |

---

## 4. Ctrl操作とシグナルの対応

| 操作      | 実体            |
| ------- | ------------- |
| Ctrl+C  | SIGINT        |
| Ctrl+Z  | SIGTSTP       |
| bg / fg | SIGCONT       |
| Ctrl+D  | EOF（シグナルではない） |

---

## 5. SIGTSTP と SIGSTOP の違い

| 項目     | SIGTSTP       | SIGSTOP |
| ------ | ------------- | ------- |
| 由来     | Terminal Stop | Stop    |
| 捕まえられる | ○             | ❌       |
| 無視できる  | ○             | ❌       |
| 礼儀     | あり            | なし      |
| 用途     | 一時退避          | 強制凍結    |

---

## 6. kill コマンドの指定方法

### 名前指定（推奨）

```bash
kill -TERM PID
kill -TSTP PID
kill -CONT PID
```

### 番号指定

```bash
kill -9 PID
kill -20 PID
```

### デフォルト

```bash
kill PID   # SIGTERM
```

---

## 7. 実務でのシグナル優先順位

```text
SIGTERM（通常終了）
 ↓
SIGINT（対話的中断）
 ↓
SIGTSTP（一時停止）
 ↓
SIGSTOP（強制停止）
 ↓
SIGKILL（最終手段）
```

---

## 8. kill -9 を使ってよい条件

* 状態を保存する必要がない
* ファイル・DB・ロックを扱っていない
* SIGTERM が効かない
* 学習用・使い捨てプロセス

### 安全な例

* sleep
* yes
* tail -f

### 危険な例

* DB（mysql / postgres）
* エディタ（vim）
* ファイルコピー中

---

## 9. kill -9 の正しい使い方（黄金ルール）

```bash
kill -TERM PID
sleep 2
kill -9 PID
```

> **礼儀 → 最終手段**

---

## 10. シグナル練習用シナリオ例

```bash
sleep 300 &
PID=$!

kill -TERM $PID
kill -STOP $PID
kill -CONT $PID
kill -9 $PID
```

---

## 11. この章の結論

* シグナルはプロセス制御の本質
* Ctrl操作・kill・bg/fg はすべてシグナル
* kill -9 は「壊れてもいいもの」にだけ使う
* 正しい順序を守れば事故は防げる

````
