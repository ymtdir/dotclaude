---
name: issue-resolution
description: GitHub Issueをブランチ作成・原子的コミットで解決する。/resolve-issueコマンドから使用。
---

# Issue Resolution スキル

GitHub Issueの内容を読み取り、適切なブランチで解決を行うスキルです。

## 解決プロセス

### ステップ1: Issue解析

```bash
gh issue view [番号]
gh issue view [番号] --comments
```

Issueの種類をラベルから判定（`issue-creation` と共通のラベル体系）:

- **bug**: 修正とテスト追加
- **enhancement**: 新機能の追加
- **refactor**: コード改善
- **ui/ux**: 見た目・操作性の改善
- **documentation**: ドキュメント修正

`--comments` は Issue 本文だけでは判定材料が不足する場合のみ実行する（コメント無し Issue では省略可）。

### ステップ2: ブランチ作成

ブランチ名は `issue-<番号>-<説明>` 形式。`<説明>` の規則:

- 英小文字 + ハイフン区切り（kebab-case）
- 3〜5 語、`<動詞>-<対象>` のパターン（例: `fix-empty-email`, `add-mau-chart`, `extract-validation-helpers`）

作成前に既存ブランチを確認する:

```bash
git branch --list "issue-<番号>-*"
```

**既存ブランチが存在した場合** はエラーハンドリング節「既存ブランチがある」に従う。存在しなければ作成:

```bash
git checkout -b issue-<番号>-<説明>
```

### ステップ3: 作業単位での解決

**重要: 各タスクごとに即座にコミット**

コミット規約は `../../rules/commit-conventions.md` に従う。

```bash
# タスク1完了 → 即コミット
git add [変更ファイル]
git commit -m "feat: [変更内容]"

# タスク2完了 → 即コミット
git add [変更ファイル]
git commit -m "test: [テスト内容]"
```

### ステップ4: 品質チェック

`package.json` の `scripts` を読み、存在するものだけ実行する（順: test → lint → typecheck）:

```bash
# scripts に含まれるもののみ実行
npm test          # "scripts.test" があれば
npm run lint      # "scripts.lint" があれば
npm run typecheck # "scripts.typecheck" があれば。無ければ npx tsc --noEmit
```

`pnpm` / `yarn` プロジェクトの場合は `pnpm` / `yarn` に置換。失敗したコマンドがあれば修正してから再実行。

## 責務の範囲

この skill は **品質チェックまで**。`git push` / PR 作成は含まない。PR 作成は `pr-creation` skill に委譲する。

## エラーハンドリング

| 症状                | 対処                                                                                                                                       |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Issueが見つからない | GitHub権限を確認                                                                                                                           |
| 既存ブランチがある  | ユーザーに以下を提示して選択を仰ぐ: (A) 既存を再利用 / (B) 別名 `issue-<番号>-<説明>-v2` で新規作成 / (C) 既存削除して作り直し（承認必須） |
| テスト失敗          | 失敗内容をユーザーに提示し、修正方針の承認後に続行                                                                                         |
