---
name: steering
description: ステアリングファイル(.steering/)による作業計画・実装追跡・振り返りを管理する。「作業計画」「ステアリング」「tasklist」と言われた時、/resolve-issueで実装計画を作成する時、またはSkill('steering')呼出時に使用。3モード: 計画(mode1)、実装(mode2)、振り返り(mode3)。
---

# Steering スキル

ステアリングファイル（`.steering/`）に基づいた実装を支援し、tasklist.mdの進捗管理を確実に行うスキルです。

## スキルの目的

- ステアリングファイル（requirements.md, design.md, tasklist.md）の作成支援
- tasklist.mdに基づいた段階的な実装管理
- **進捗の自動追跡とtasklist.md更新の強制**
- 実装完了後の振り返り記録

## 使用タイミング

1. **作業計画時**: ステアリングファイルを作成する時（モード1）
2. **実装時**: tasklist.mdに従って実装する時（モード2）
3. **検証時**: 実装完了後の振り返りを記録する時（モード3）

---

## モード1: ステアリングファイル作成

### 手順

1. **ステアリングディレクトリの作成**
   現在の日付を取得し、`.steering/[YYYYMMDD]-[機能名]/` の形式でディレクトリを作成

2. **永続ドキュメントの確認**
   - `docs/product-requirements.md`
   - `docs/functional-design.md`
   - `docs/architecture.md`
   - `docs/repository-structure.md`
   - `docs/development-guidelines.md`

   これらを読んで、プロジェクトの方針を理解する

3. **テンプレートからファイル作成**

   以下のテンプレートを読み込み、プレースホルダーを具体的な内容に置き換えてファイルを作成:
   - `./assets/templates/requirements.md` → `.steering/[日付]-[機能名]/requirements.md`
   - `./assets/templates/design.md` → `.steering/[日付]-[機能名]/design.md`
   - `./assets/templates/tasklist.md` → `.steering/[日付]-[機能名]/tasklist.md`

4. **tasklist.mdの詳細化**
   requirements.mdとdesign.mdに基づいて、tasklist.mdを詳細化:
   - 各フェーズのタスクを具体的に記述
   - サブタスクも明確に
   - 実装の順序を明記

---

## モード2: 実装（最重要）

tasklist.mdに従って実装を進め、**進捗を確実にドキュメントに記録**します。

### 重要な原則

タスク完了に関する絶対的なルールは `./references/task-completion-rules.md` を参照。

**核心ルール**:

- tasklist.mdの全タスクが`[x]`になるまで作業を継続
- タスクスキップは技術的理由のみ許可
- TodoWriteは補助的メモ、**tasklist.mdが正式なドキュメント**

### 実装フロー

#### ステップ1: tasklist.mdを読み込む

```
Read('.steering/[日付]-[機能名]/tasklist.md')
```

全体のタスク構造を把握し、次に着手すべきタスクを特定する。

#### ステップ2: TodoWriteでタスク管理開始

tasklist.mdの内容に基づいてTodoWriteツールでタスクリストを作成（補助的メモ）。

#### ステップ3: タスクループ

詳細な手順は `./references/implementation-flow.md` を参照。

概要:

1. 次の未完了タスク（`[ ]`）を特定
2. Editツールで`[ ]`→`[x]`に更新
3. TodoWriteでもステータス更新
4. 実装を実行
5. 完了を記録
6. 次のタスクへ（繰り返し）

#### ステップ4: 全タスク完了チェック

全フェーズ完了後、振り返り前に必ず未完了タスクがないか確認。
詳細は `./references/implementation-flow.md` の「全タスク完了チェック」セクションを参照。

#### ステップ5: 振り返り記録

すべてのタスクが`[x]`であることを確認後、tasklist.mdの「実装後の振り返り」セクションを更新。

---

## モード3: 振り返り

### 手順

1. **tasklist.mdを読み込む**

   ```
   Read('.steering/[日付]-[機能名]/tasklist.md')
   ```

2. **振り返り内容を作成**
   - 実装完了日
   - 計画と実績の差分（計画と異なった点）
   - 学んだこと（技術的な学び、プロセス上の改善点）
   - 次回への改善提案

3. **Editツールで更新**
   tasklist.mdの「実装後の振り返り」セクションを更新

4. **ユーザーに報告**
   「振り返りをtasklist.mdに記録しました。内容を確認してください。」

---

## トラブルシューティング

### tasklist.mdの更新を忘れた場合

1. 即座にtasklist.mdを読み込み、完了したタスクをすべてEditツールで`[x]`に更新
2. ユーザーに遅延を報告
3. 次のタスクから確実に更新する

### tasklist.mdと実装の乖離

1. tasklist.mdに注釈を追加: `- [x] タスク名（実装方法を変更: 理由）`
2. 必要に応じて新しいタスクを追加
3. 設計変更が大きい場合はdesign.mdも更新

## 重要なリマインダー

- TodoWriteは揮発的なメモ（ユーザーには見えない）
- **tasklist.mdこそが永続的なドキュメント（ユーザーが見る）**
- 実装中は常に「ユーザーがtasklist.mdを見たときに進捗が分かるか？」を自問してください
