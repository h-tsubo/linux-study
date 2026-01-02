# 第5章 プロセスとジョブ管理（process_job.md）

## この章のゴール
- プロセスとジョブの違いを説明できる
- ps / jobs / fg / bg / kill を正しく使い分けられる
- Ctrl+C / Ctrl+Z / Ctrl+D の意味を理解する
- Linuxのプロセス状態（STAT）を読める

---

## 1. プロセスとジョブの違い

### プロセス（process）
- OS（カーネル）が管理
- 識別子：PID
- 確認コマンド：ps / top
- 操作：kill

### ジョブ（job）
- シェル（bash）が管理
- 識別子：%1, %2 …
- 確認コマンド：jobs
- 操作：fg / bg

> 同じ実体（sleepなど）を  
> OS視点で見ているのが「プロセス」  
> シェル視点で見ているのが「ジョブ」

---

## 2. ps コマンド

### 全プロセスを表示
```bash
ps aux
````

* a : 全ユーザー
* u : ユーザー向け表示
* x : 端末に紐づかないプロセスも含む

### grep と組み合わせ

```bash
ps aux | grep sleep
```

※ grep 自身も表示される点に注意

```bash
ps aux | grep [s]leep
```

---

## 3. jobs コマンド

```bash
sleep 100 &
jobs
```

出力例：

```text
[1]+  Running  sleep 100 &
```

* `[1]` → ジョブ番号
* Running → 停止していないという意味（CPU使用中とは限らない）

---

## 4. フォアグラウンド / バックグラウンド

### &（非同期実行）

```bash
sleep 100 &
```

* シェルは待たずにプロンプトを返す
* 本質は「非同期実行」

---

## 5. Ctrlキー操作

### Ctrl+C（SIGINT）

* 実行中プロセスを終了させる
* 再開不可

```bash
sleep 100
Ctrl+C
```

---

### Ctrl+Z（SIGTSTP）

* プロセスを一時停止
* メモリ上に残る
* 再開可能

```bash
sleep 100
Ctrl+Z
jobs
```

---

### Ctrl+D（EOF）

* 入力終了を通知
* cat では入力終了
* shell では logout

```bash
cat
hello
Ctrl+D
```

---

## 6. fg / bg の正体

### 重要な理解

> fg / bg は
> 「フォアグラウンド・バックグラウンドに移す」コマンドではなく
> **停止中ジョブを再開（SIGCONT）するコマンド**

### bg

```bash
bg %1
```

* SIGCONT を送る
* バックグラウンドで再開

### fg

```bash
fg %1
```

* SIGCONT を送る
* フォアグラウンドで再開

---

## 7. kill コマンド

### PID指定

```bash
kill 1234
```

### ジョブ指定

```bash
kill %1
```

* 成功時は何も出力しない
* 表示される `[1]+ Terminated` は bash のメッセージ

---

## 8. リダイレクトできない理由

```bash
kill %1 > log.txt
```

* kill 自身は stdout に何も出さない
* bash のジョブ通知はリダイレクト対象外
* そのためファイルは空

---

## 9. プロセス状態（STAT）

| STAT | 意味              |
| ---- | --------------- |
| R    | Running（CPU使用中） |
| S    | Sleeping（待機中）   |
| T    | Stopped（Ctrl+Z） |
| D    | 割り込み不可のI/O待ち    |
| Z    | Zombie          |

### sleep が S になる理由

* CPUを使わず、タイマー待ちをしているため
* 正常な実行状態

---

## 10. yes > /dev/null

```bash
yes > /dev/null
```

* yes：無限に文字を出力
* /dev/null：すべて捨てる
* 結果：CPU負荷をかけ続ける

学習・検証用コマンド

---

## 11. 使い分けまとめ

| やりたいこと     | 操作     |
| ---------- | ------ |
| 完全に止めたい    | Ctrl+C |
| 一時停止したい    | Ctrl+Z |
| 裏で再開       | bg     |
| 表で再開       | fg     |
| 状態確認（bash） | jobs   |
| 状態確認（OS）   | ps     |

---

## この章の結論

* ジョブ制御はシグナル操作
* bg / fg の本質は SIGCONT
* 「実行中」と「CPU使用中」は別
* Linuxは状態を細かく分けて管理している
