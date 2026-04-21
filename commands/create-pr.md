---
description: 現在のブランチからPull Requestを作成。変更分析→PR本文生成→ラベル適用→自動レビュー。
---

# Pull Request作成

このコマンドは、現在のブランチの変更内容を分析し、適切なテンプレートで PR を作成します。

## 手順

### ステップ1: pr-creation スキルの実行

1. **pr-creation スキル**をロード
2. スキルの手順（ブランチ情報収集 → Issue 特定 → ラベル判定 → テンプレ適用 → push → `gh pr create` → pr-reviewer 起動）に全て委譲する

### ステップ2: 結果の報告

`gh pr create` の出力 URL 末尾から PR 番号を抽出（スキル側で実施済み）。以下のフォーマットで報告する:

```
✅ PR #[番号]を作成しました。

タイトル: [PRタイトル]
種類: [bug/enhancement/ui/ux/documentation/refactor]
関連Issue: #[Issue番号] または なし
URL: [GitHub PR URL]

レビュー待ちです。
```

## 完了条件

- Pull Request が正常に作成される
- 関連 Issue がある場合は紐付け完了
- ラベルに対応するテンプレートが適用される
- 自動レビュー（pr-reviewer agent）が GitHub に投稿される
