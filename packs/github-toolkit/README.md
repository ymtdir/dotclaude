# github-toolkit

GitHub の PR / Issue 周りを Claude Code 上で完結させるためのツールキット。Issue 起票から原子的コミット・PR 作成・PR レビューまで一連のワークフローをカバーする。

## 含まれるもの

| 種別  | 名前                    | 役割                                                     |
| ----- | ----------------------- | -------------------------------------------------------- |
| skill | `create-issue`          | 課題を Issue として起票                                  |
| skill | `init-issues`           | 初期開発 Issue 群を一括作成（要件/設計ドキュメント前提） |
| skill | `resolve-issue`         | Issue をブランチ作成 + 原子的コミットで解決              |
| skill | `create-pr`             | 現ブランチから PR を作成（自動レビュー連携）             |
| skill | `review-pr`             | pr-reviewer agent のレビューロジック                     |
| agent | `pr-reviewer`           | PR レビューの専門エージェント                            |
| rule  | `label-definitions.md`  | 標準 5 ラベル定義                                        |
| rule  | `commit-conventions.md` | コミット規約                                             |
| rule  | `gh-usage.md`           | `gh` コマンド実行時の `env -u GITHUB_TOKEN` 前置規則     |

## インストール

対象リポジトリのルートで以下を実行：

```bash
curl -fsSL https://raw.githubusercontent.com/ymtdir/dotclaude/main/install.sh | bash -s -- add github-toolkit
```

`<repo>/.claude/` 配下に展開され、Claude Code がそのまま認識する。

## アンインストール

```bash
curl -fsSL https://raw.githubusercontent.com/ymtdir/dotclaude/main/install.sh | bash -s -- remove github-toolkit
```

`.claude/.dotclaude-manifest.json` を参照し、この pack 由来のファイルだけを削除する。他 pack が参照中のファイル（`commit-conventions.md` 等）は残る。
