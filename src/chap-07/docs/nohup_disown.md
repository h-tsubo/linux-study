# 第7章 端末と切り離してプロセスを生かす  
## nohup / disown / SIGHUP / systemd 入門

---

## この章のゴール

- なぜ **ターミナルを閉じるとプロセスが死ぬのか**説明できる
- SIGHUP の正体を理解する
- nohup と disown の違いを使い分けられる
- 「& だけでは不十分」な理由を理解する
- systemd がなぜ最終解なのかを知る

---

## 1. 端末とプロセスの関係

通常の構造：

```

ターミナル（tty）
└─ bash
└─ sleep / python / server

````

- プロセスは **端末（tty）にぶら下がっている**
- 端末が消えると、OS は **SIGHUP** を送る

---

## 2. SIGHUP とは何か

| 項目 | 内容 |
|---|---|
| シグナル名 | SIGHUP |
| 番号 | 1 |
| 由来 | Hang UP（電話を切る） |
| 本来の意味 | 端末・回線が切断された |

### デフォルト動作
- 多くのプログラムは **終了する**

```bash
sleep 300 &
kill -HUP PID   # sleep は終了
````

---

## 3. よくある事故

```bash
sleep 300 &
logout
```

→ 再ログインすると **プロセスが消えている**

理由：

* logout → SIGHUP
* プロセスが終了

---

## 4. nohup とは何か

### 定義

> **SIGHUP を無視する設定でプロセスを起動する**

```bash
nohup sleep 300 &
```

### 特徴

* プロセス自身が SIGHUP を無視
* ssh 切断・logout でも生き残る
* 標準出力は `nohup.out` に書かれる

```bash
kill -HUP PID   # nohup なら死なない
```

---

## 5. disown とは何か

### 定義

> **bash が job 管理をやめ、logout 時に SIGHUP を送らなくする**

```bash
sleep 300 &
disown %1
```

### 特徴

* bash 専用
* プロセス自体は普通のまま
* 外部から `kill -HUP` を送ると普通に死ぬ

```bash
kill -HUP PID   # disown でも死ぬ
```

---

## 6. nohup と disown の違い（重要）

| 観点        | nohup  | disown  |
| --------- | ------ | ------- |
| 効く場所      | プロセス自身 | bash    |
| SIGHUP    | 無視する   | 送られないだけ |
| bash以外    | OK     | NG      |
| kill -HUP | 生きる    | 死ぬ      |
| 実務安全度     | 高      | 中       |

### 一言で

> **nohup = プロセスが強くなる**
> **disown = bash が手放す**

---

## 7. `&` だけではダメな理由

```bash
sleep 300 &
```

* バックグラウンドにはなる
* **SIGHUP 対策は一切されていない**

👉 logout / ssh切断で死ぬ

---

## 8. 実務での定番パターン

```bash
nohup command > app.log 2>&1 &
```

意味：

* SIGHUP 無視
* 標準出力・エラーをログへ
* バックグラウンド実行

---

## 9. プロセスが nohup か確認する方法

### 方法①：実際に HUP を送る（最も分かりやすい）

```bash
kill -HUP PID
```

* 生きる → nohup 等
* 死ぬ → 通常プロセス

---

### 方法②：/proc で確認（内部）

```bash
grep SigIgn /proc/PID/status
```

* SIGHUP が無視されていれば nohup 相当

---

## 10. systemd とは（導入）

### 一言で

> **systemd = system daemon（PID 1）**

* Linux 起動時に最初に動く
* すべてのサービスの親
* 端末に依存しない

```
systemd (PID 1)
 └─ nginx
 └─ mysql
```

---

## 11. nohup / disown と systemd の位置づけ

| 用途    | 適切な手段          |
| ----- | -------------- |
| 学習・検証 | nohup / disown |
| 一時作業  | nohup          |
| 本番・常駐 | systemd        |

> **nohup は応急処置
> systemd は正規運用**

---

## 12. この章のまとめ

* 端末が消えると SIGHUP が飛ぶ
* `&` は関係ない
* nohup は SIGHUP を無視
* disown は bash が送らない
* 本番では systemd を使う

