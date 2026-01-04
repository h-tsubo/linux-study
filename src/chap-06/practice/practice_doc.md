# 第6章：シグナルに慣れるための実践シナリオ集

## シナリオ①

### 🎯 目的

**SIGTERM（通常終了）を体感する**

```bash
sleep 300 &
jobs
```

```bash
kill %1
```

### 観察

```bash
jobs
ps aux | grep sleep
```

✅ sleep は **消えている**
✅ エラーなし
👉 **丁寧に終了**

---

## シナリオ②

### 🎯 目的

**SIGINT（Ctrl+C）は人間向け中断**

```bash
sleep 300
```

```text
Ctrl + C
```

### 観察

```bash
ps aux | grep sleep
```

✅ sleep は存在しない
👉 **対話的中断**

---

## シナリオ③

### 🎯 目的

**SIGTSTP（Ctrl+Z）と再開の関係**

```bash
sleep 300
```

```text
Ctrl + Z
```

```bash
jobs
ps aux | grep sleep
```

👉 `STAT = T`

```bash
bg %1
```

```bash
ps aux | grep sleep
```

👉 `STAT = S`

---

## シナリオ④

### 🎯 目的

**SIGSTOP（強制停止）と SIGTSTP の違い**

```bash
sleep 300 &
ps aux | grep sleep
```

```bash
kill -STOP <PID>
```

```bash
ps aux | grep sleep
```

👉 `STAT = T`

再開：

```bash
kill -CONT <PID>
```

👉 再び `S`

---

## シナリオ⑤

### 🎯 目的

**SIGTERM → SIGKILL の安全な順序**

```bash
sleep 300 &
PID=$!
```

```bash
kill -TERM $PID
sleep 1
ps aux | grep sleep
```

（もういないはず）

※ 反応しない想定で練習：

```bash
kill -9 $PID
```

👉 **kill -9 は最後**

---

## シナリオ⑥

### 🎯 目的

**SIGCONT の正体を理解する**

```bash
sleep 300
Ctrl + Z
```

```bash
kill -CONT %1
```

```bash
jobs
```

👉 **bg / fg と同じ効果**

---

## シナリオ⑦

### 🎯 目的

**CPUを使うプロセス（R状態）にシグナルを送る**

```bash
yes > /dev/null &
ps aux | grep yes
```

👉 `STAT = R`

```bash
kill %1
```

👉 即終了

---

## シナリオ⑧

### 🎯 目的

**kill の指定方法を使い分ける**

```bash
sleep 300 &
PID=$!
```

```bash
kill -TERM $PID
```

```bash
sleep 300 &
PID=$!
kill -15 $PID
```

```bash
sleep 300 &
PID=$!
kill -SIGTERM $PID
```

👉 **すべて同じ意味**

---

## シナリオ⑨

### 🎯 目的

**kill が何も出力しない理由を確認**

```bash
sleep 300 &
kill %1 > out.txt
```

```bash
cat out.txt
```

👉 空

理由：

* kill は成功時 stdout に何も出さない
* 表示は bash のジョブ通知
