---
name: pr-creation
description: 現在のブランチの変更からPull Requestを作成し自動レビューする。「PR作成」「/create-pr」「pull request」と言われた時、または実装完了後レビュー準備ができた時に使用。変更分析→テンプレート選択→PR作成→ラベル適用→自動レビュー。
---

# Pull Request Creation スキル

現在のブランチの変更内容を分析し、GitHub Pull Requestを作成するスキルです。

## 使用方法

`/create-pr`コマンドから呼び出され、以下の処理を行います：

1. ブランチと変更内容の分析
2. 関連Issueの特定
3. 適切なテンプレートでPR作成
4. レビュー準備の完了

## PR作成プロセス

**注**: ラベル判定ルールは[shared/label-definitions.md](../shared/references/label-definitions.md)を参照

### ステップ1: ブランチ情報の収集

```bash
# 現在のブランチ
git branch --show-current

# ベースブランチとの差分
git diff --stat origin/main...HEAD

# コミット履歴
git log origin/main..HEAD --oneline

# 変更ファイル一覧
git diff --name-only origin/main...HEAD
```

### ステップ2: Issue番号の特定

ブランチ名から自動判定:

- `issue-123-fix-bug` → Issue #123
- `feature/user-auth` → コミットメッセージから検索
- その他 → 最近のコミットメッセージから`#\d+`を検索

### ステップ3: ラベルの判定

関連Issueが存在する場合は、**Issueのラベルをそのまま継承**します。
Issueがない場合のみ、コミットプレフィックスから判定します。

判定ルールの詳細は [shared/label-definitions.md](../shared/references/label-definitions.md) を参照。

### ステップ4: テンプレートの適用

判定された種類に応じてテンプレートを選択:

- **bug** → `./assets/templates/bug.md`
- **enhancement** → `./assets/templates/enhancement.md`
- **documentation** → シンプルなドキュメント更新形式
- **refactor** → `./assets/templates/refactor.md`

コミットプレフィックスの詳細は `../shared/references/commit-conventions.md` を参照。

### ステップ5: PR作成

```javascript
mcp__github__create_pull_request({
  owner: '[owner]',
  repo: '[repo]',
  title: '[PRタイトル]',
  body: '[テンプレートで生成した本文]',
  head: '[現在のブランチ]',
  base: 'main',
  draft: false,
});
```

PR作成後、PR番号を取得：

```bash
# PR番号を取得（作成したPRの番号を取得）
PR_NUMBER=$(gh pr view --json number -q ".number")
# またはPR URLから番号を抽出
# PR_URL=$(gh pr create ... | tail -1)
# PR_NUMBER=$(basename "$PR_URL")

# リポジトリ情報を取得
OWNER=$(gh repo view --json owner -q ".owner.login")
REPO=$(gh repo view --json name -q ".name")
```

### ステップ6: 自動ラベル付与

PR作成成功後、適切なラベルを自動付与します。

**ラベル付与の流れ**:

1. 関連Issueがある場合 → **Issueのラベルを継承**（最優先）
2. 関連Issueがない場合 → コミットプレフィックスから判定
3. GitHub APIを使用してラベルを付与

**実装のポイント**:

- ラベルが存在しない場合は警告を表示（自動作成はしない）
- `chore:`や`test:`より`feat:`や`fix:`を優先（本質的な変更を重視）

**ラベル付与コマンド**:

```bash
# 方法1: JSONをパイプで渡す（最も確実）
echo '{"labels":["enhancement","ui"]}' | \
  gh api repos/$OWNER/$REPO/issues/$PR_NUMBER/labels \
  --method POST --input -

# 方法2: gh pr editを使用（権限によってはエラーになる可能性）
# gh pr edit $PR_NUMBER --add-label "enhancement,ui"

# 注意:
# - -f labels[]=enhancement はzshで動作しない
# - --field labels='["enhancement","ui"]' は文字列として解釈される
```

ラベルマッピングルールは [shared/label-definitions.md](../shared/references/label-definitions.md) を参照。

### ステップ7: 自動レビュー実行

PR作成後、即座にレビューを実行してGitHubに投稿：

```javascript
// 1. pr-reviewerサブエージェントを起動
Task({
  subagent_type: 'pr-reviewer',
  description: 'Review PR #[PR番号]',
  prompt: `Pull Request #[PR番号]のレビューを実行してください。

  特に以下を確認:
  - コードの品質と一貫性
  - ドキュメントの整合性
  - テストの実施状況
  - 関連Issueとの整合性`,
});

// 2. サブエージェントのレビュー結果を受け取ったら、GitHubに投稿
mcp__github__pull_request_review_write({
  method: 'create',
  owner: '[owner]',
  repo: '[repo]',
  pullNumber: [PR番号],
  body: '[レビュー結果のサマリー]',
  event: 'COMMENT', // 自分のPRにはCOMMENTのみ可能
});

// 注意: 自分が作成したPRには"APPROVE"できないため、"COMMENT"を使用
```

**レビュー投稿の内容**：

- チェックリスト形式での確認項目
- 良い点と改善点の指摘
- 関連ドキュメントとの整合性確認
- テスト実行結果の確認

## PRタイトルの生成

### パターン1: Issue連携あり

```
fix: [Issue概要] (#123)
feat: [Issue概要] (#456)
refactor: [Issue概要] (#789)
style: [Issue概要] (#012)
docs: [Issue概要] (#345)
```

### パターン2: Issue連携なし

```
fix: [最初のコミットメッセージから抽出]
feat: [主要な変更内容を要約]
refactor: [リファクタリング対象を明記]
style: [UI/UX改善内容を明記]
docs: [ドキュメント更新内容を明記]
```

## PR本文の構成

### 共通セクション

```markdown
## 概要

[変更内容の要約]

## 関連Issue

Closes #[Issue番号]（あれば）

## 変更内容

[主要な変更点を箇条書き]

## テスト

- [ ] ユニットテスト: [結果]
- [ ] 統合テスト: [結果]
- [ ] 手動テスト: [実施内容]

## スクリーンショット

[UIの変更があれば]

## レビューポイント

[特に確認してほしい箇所]
```

## コミット履歴の整理

PRに含まれるコミットを分析して整理:

```markdown
## コミット履歴

### 機能追加 (feat)

- ログイン機能を追加 (abc123)
- バリデーション処理を実装 (def456)

### バグ修正 (fix)

- セッション保存エラーを修正 (ghi789)

### テスト (test)

- ログインのE2Eテストを追加 (jkl012)
```

## 自動チェック

PR作成前の確認:

1. **未コミットの変更がないか**

   ```bash
   git status --short
   ```

2. **リモートとの同期**

   ```bash
   git fetch origin
   git status -sb
   ```

3. **テストの実行**
   ```bash
   npm test
   npm run lint
   ```

## エラーハンドリング

### ブランチがmainの場合

```
❌ mainブランチから直接PRは作成できません
新しいブランチを作成してください
```

### 変更がない場合

```
⚠️ ベースブランチとの差分がありません
変更をコミットしてから実行してください
```

### コンフリクトがある場合

```
⚠️ マージコンフリクトが検出されました
以下のファイルで競合しています:
- [ファイルリスト]

解決してから再度実行してください
```
