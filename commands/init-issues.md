---
description: /setup-project完了後に初期開発Issue群を一括作成。プロジェクトドキュメントを分析し依存関係付きIssueセットを生成。
---

# 初期Issue一括作成

プロジェクトの開発を開始するための基本的な Issue セットを作成します。

## 前提条件

- `/setup-project` が完了していること
- 以下のドキュメントが存在すること:
  - docs/requirements.md
  - docs/basic-design.md
  - docs/detailed-design.md
  - docs/development-guide.md

### 前提条件未達時

いずれかのドキュメントが欠落している場合は実行を中止し、不足ファイル名と共に「`/setup-project` を実行してから再試行してください」とユーザーに通知する。

## 手順

### ステップ1: プロジェクト分析

1. 4 つのドキュメントを全て読み込む
2. プロジェクトタイプと技術スタックを確認
3. 主要機能を抽出

### ステップ2: Issue 作成計画

プロジェクトに応じた **5〜10 本の標準 Issue セット** を設計します。

- 開発環境セットアップ
- 基本プロジェクト構造
- データモデル実装
- プロジェクト固有の機能 Issue（UI 要件があれば ui/ux の Issue も含む）

各 Issue について以下を決定:

- **タイトル**: issue-creation skill の規則に従う（接頭辞なし、課題の要点を 1 行・50 文字以内）
- **本文**: 自由文（skill が分類・テンプレ適用を行う）
- **種類の目安**（参考）: bug / enhancement / ui/ux / documentation / refactor の 5 種のいずれか。最終判定は issue-creation skill に委ねる
- **依存関係**: 本文末尾に `## 依存関係` 節を設け `前提: #N` の形式で記載（初回は番号未確定なので、作成時に番号を順次埋める）

### ステップ3: issue-creation スキルで各 Issue を作成

**issue-creation スキル**をロードし、計画した各 Issue を順番に作成します。

**重要**: ラベル判定・テンプレート適用のロジックは issue-creation スキルに一元化されているため、このコマンドでは独自にラベルを決定しない。

**Issue 番号取得ループ**:

```bash
# 1 本ずつ順番に作成し、URL 末尾から番号を抽出して次の Issue 本文の `前提: #N` に反映する
URL=$(gh issue create --title "..." --label "..." --body "...")
N=$(echo "$URL" | grep -oE '[0-9]+$')
# 次の Issue 本文の `前提: #N` にこの N を差し込んでから次を作成
```

### ステップ4: 結果レポート

```
✅ 初期Issue作成完了！

作成されたIssue:
#7  開発環境セットアップ (enhancement)
#8  基本プロジェクト構造 (enhancement)          ← 前提: #7
#9  データモデル実装 (enhancement)              ← 前提: #8
#10 共通UI基盤・ダークモード対応 (ui/ux)        ← 前提: #8
#11 認証・認可基盤 (enhancement)               ← 前提: #9
...

次のステップ:
/resolve-issue 7  # 開発を開始
```
