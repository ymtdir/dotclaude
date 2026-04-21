# docs-toolkit

プロジェクト初期ドキュメント（要件定義・基本設計・詳細設計・開発ガイド）の **作成** と、既存ドキュメントの **レビュー** を Claude Code 上で行うためのツールキット。

## 含まれるもの

| 種別          | 名前                           | 役割                                 |
| ------------- | ------------------------------ | ------------------------------------ |
| command       | `/setup-project`               | 4 ドキュメントを対話的に一括作成     |
| command       | `/review-doc`                  | 指定ドキュメントを 5 観点でレビュー  |
| skill         | `requirements-definition`      | 要件定義書の作成                     |
| skill         | `basic-design`                 | 基本設計書の作成                     |
| skill         | `detailed-design`              | 詳細設計書の作成                     |
| skill         | `development-guide`            | 開発ガイドラインの作成               |
| skill         | `doc-review`                   | ドキュメント品質レビュー             |
| agent         | `doc-reviewer`                 | ドキュメントレビュー専門エージェント |
| rule          | `document-generation-guide.md` | ドキュメント生成時のフォーマット規約 |
| rule          | `commit-conventions.md`        | コミット規約                         |

## インストール

対象リポジトリのルートで以下を実行：

```bash
curl -fsSL https://raw.githubusercontent.com/ymtdir/dotclaude/main/install.sh | bash -s -- add docs-toolkit
```

`<repo>/.claude/` 配下に展開され、Claude Code がそのまま認識する。

## アンインストール

```bash
curl -fsSL https://raw.githubusercontent.com/ymtdir/dotclaude/main/install.sh | bash -s -- remove docs-toolkit
```

`.claude/.dotclaude-manifest.json` を参照し、この pack 由来のファイルだけを削除する。他 pack が参照中のファイル（`commit-conventions.md` 等）は残る。
