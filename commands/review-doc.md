---
description: doc-reviewerサブエージェントによるドキュメント詳細レビュー。引数にドキュメントパスを指定。
---

# ドキュメントレビュー

引数: ドキュメントパス（例: `/review-doc docs/requirements.md`）

## 手順

### ステップ1: ドキュメントの存在確認

指定されたドキュメントが存在するか確認します。

### ステップ2: doc-reviewerサブエージェント起動

Agent toolを使用してdoc-reviewerサブエージェントを起動します:

- subagent_type: `doc-reviewer`
- prompt: 「[ドキュメントパス]を詳細にレビューしてください。」

### ステップ3: レビュー結果の要約

サブエージェントのレビューレポートの要点をユーザーに報告します。
