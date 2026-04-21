---
description: 課題をGitHub Issueとして作成。種類を分類しテンプレート適用後GitHubに投稿。
---

# 開発中の課題をIssue化

このコマンドは、開発作業中に発見した課題を GitHub Issue として記録します。

## 手順

### ステップ1: 課題説明の取得

ユーザーが入力した自由文をそのまま課題説明として取得する。オプションフラグ（`--type` など）は受け付けない（種類判定は issue-creation skill に委ねる）。

### ステップ2: issue-creationスキルの実行

1. **issue-creation スキル**をロード
2. ステップ1 で取得した自由文を課題説明として skill に渡す
3. skill の手順（分類 → コンテキスト収集 → テンプレ適用 → `gh issue create`）に従って Issue を作成する

### ステップ3: 結果の報告

`gh issue create` の出力は Issue の URL を返す。末尾から Issue 番号を抽出し、以下のフォーマットで報告する:

```
✅ Issue #[番号]を作成しました。

タイトル: [課題タイトル]
種類: [bug/enhancement/ui/ux/documentation/refactor]
URL: [GitHub Issue URL]

現在の作業を続けてください。
```
