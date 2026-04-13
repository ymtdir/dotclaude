# dotclaude

Claude Code 用の設定とパッケージ群を管理するリポジトリ。

- **settings.json** はホーム（`~/.claude/settings.json`）にシンボリックリンクで常駐
- **agents / commands / skills / rules** は用途別 **pack** にまとめ、必要なリポジトリにだけ `install.sh` で配布

## ディレクトリ構成

| パス                                           | 役割                                                                                                     |
| ---------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| [settings.json](settings.json)                 | Claude Code 全体設定（permissions, hooks, sandbox など）。`~/.claude/settings.json` にシンボリックリンク |
| [install.sh](install.sh)                       | リモート実行用インストーラ（`list` / `add` / `remove`）                                                  |
| [registry.json](registry.json)                 | 利用可能な pack の一覧                                                                                   |
| [packs/github-toolkit/](packs/github-toolkit/) | PR/Issue 作成・解決・レビュー一式                                                                        |
| [packs/docs-toolkit/](packs/docs-toolkit/)     | 要件→基本→詳細→開発ガイド作成とドキュメントレビュー一式                                                  |
| [packs/shared/](packs/shared/)                 | 複数 pack 共通ファイルの実体（コミット規約など）                                                         |

## settings.json のセットアップ

```bash
ln -s ~/dotclaude/settings.json ~/.claude/settings.json
```

## pack のインストール

対象リポジトリのルートで以下を実行すると、`<repo>/.claude/` 配下に必要なファイルが配置される。

```bash
# 利用可能な pack を一覧表示
curl -fsSL https://raw.githubusercontent.com/ymtdir/dotclaude/main/install.sh | bash -s -- list

# pack を追加
curl -fsSL https://raw.githubusercontent.com/ymtdir/dotclaude/main/install.sh | bash -s -- add github-toolkit

# pack を削除
curl -fsSL https://raw.githubusercontent.com/ymtdir/dotclaude/main/install.sh | bash -s -- remove github-toolkit
```

各 pack の詳細は対応する README を参照：

- [packs/github-toolkit/README.md](packs/github-toolkit/README.md)
- [packs/docs-toolkit/README.md](packs/docs-toolkit/README.md)

## 依存

`install.sh` は `bash` / `curl` / `jq` / `tar` を利用する（macOS / 一般的な Linux で標準）。

## ローカル開発

公開前のパッケージを試す場合：

```bash
DOTCLAUDE_SOURCE=/path/to/dotclaude bash install.sh add github-toolkit
```
