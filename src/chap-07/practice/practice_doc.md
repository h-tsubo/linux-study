了解。第7章（nohup / disown / SIGHUP）に**慣れるための“手で叩く用”シナリオ**を、流れが分かりやすいように **目的→手順→観察**でいくつか作ります。
（全部 `sleep` なので安全。`PID=$!` も練習になる）

---

# 第7章：nohup / disown / SIGHUP 慣れシナリオ集

## 0. 準備

```bash
cd /workspace
mkdir -p chap-07/practice
cd chap-07/practice
```

---

## シナリオA：SIGHUPの基本（普通のプロセスはHUPで死ぬ）

### 🎯目的

* `kill -HUP` が「端末切断相当」であることを体で覚える

```bash
sleep 300 &
PID=$!
echo "PID=$PID"
ps -p $PID -o pid,tty,stat,cmd
```

HUPを送る：

```bash
kill -HUP $PID
```

確認：

```bash
ps -p $PID
echo $?   # 0なら存在、1ならいない
```

✅ いなくなる（sleepはデフォルトでHUPで終了）

---

## シナリオB：nohup（HUPが来ても無視して生き残る）

### 🎯目的

* `nohup` が「SIGHUPを無視する設定で起動」だと確認する

```bash
nohup sleep 300 &
PID=$!
echo "PID=$PID"
ps -p $PID -o pid,tty,stat,cmd
```

HUPを送る：

```bash
kill -HUP $PID
```

確認：

```bash
ps -p $PID -o pid,tty,stat,cmd
```

✅ 生きてる（nohupだから）

追加観察（nohup.outの存在）：

```bash
ls -l nohup.out
tail -n 5 nohup.out
```

---

## シナリオC：disown（bashが“面倒を見ない”＝logout時にHUPを送らない）

### 🎯目的

* disownが「プロセスをnohup化する」のではないと理解する
* だから `kill -HUP` を直接送ると普通に死ぬ

```bash
sleep 300 &
PID=$!
echo "PID=$PID"
jobs
disown %1
jobs   # ここで消える（または表示が変わる）
```

ここが重要：HUPを直接送る

```bash
kill -HUP $PID
ps -p $PID
```

✅ 死ぬ（disownはHUP無視にしない）

---

## シナリオD：nohup と disown の「目的の違い」を体で理解する

### 🎯目的

* **nohup＝プロセス側がHUP無視**
* **disown＝bash側がHUPを送らない**

まずA：nohup

```bash
nohup sleep 300 &
PID_N=$!
echo "nohup PID=$PID_N"
```

次にB：disown

```bash
sleep 300 &
PID_D=$!
echo "disown PID=$PID_D"
disown %1
```

HUPをそれぞれに送る：

```bash
kill -HUP $PID_N
kill -HUP $PID_D
```

確認：

```bash
ps -p $PID_N -o pid,stat,cmd
ps -p $PID_D -o pid,stat,cmd
```

✅ nohupは生きる
✅ disownは死ぬ
→ **違い確定**

---

## シナリオE：ログをちゃんと残す“実務型 nohup”

### 🎯目的

* 実務でよくある形（stdout/stderrをファイルへ）

```bash
nohup bash -c 'for i in {1..5}; do echo "tick $i"; sleep 1; done' \
  > app.log 2>&1 &
PID=$!
echo "PID=$PID"
```

ログ確認：

```bash
tail -f app.log
```

止める（別ターミナル or Ctrl+Cでtailを止めてから）：

```bash
kill -TERM $PID
```

---

## シナリオF：`$!`（直前バックグラウンドPID）に慣れる

### 🎯目的

* `$!` が「直前の & のPID」だと体で覚える

```bash
sleep 300 &
PID1=$!
sleep 400 &
PID2=$!

echo "PID1=$PID1"
echo "PID2=$PID2"
ps -p $PID1,$PID2 -o pid,stat,cmd
```

片方だけ止める：

```bash
kill -TERM $PID1
ps -p $PID1,$PID2 -o pid,stat,cmd
```

---

## 後片付け（残ってたら止める）

```bash
pkill -f "sleep 300" || true
pkill -f "sleep 400" || true
```

---

# 仕上げチェック（答えられたら合格）

* `nohup` は何を無視する？
* `disown` は誰が何をしなくなる？
* disownしたプロセスに `kill -HUP` を送るとどうなる？なぜ？
* `&` だけで安心できない理由は？

