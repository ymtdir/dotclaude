# dotclaude

Claude Code 用の設定とパッケージ群を管理するリポジトリ。

- **settings.json** はホーム（`~/.claude/settings.json`）にシンボリックリンクで常駐（全プロジェクト共通の設定）
- **.claude/settings.template.json** は各プロジェクトの `.claude/settings.json` に配置するためのテンプレート（プロジェクト固有の設定）
- **skills / agents / rules** はリポジトリ直下にフラット配置し、**pack** でグループ定義して `install.sh` で必要なリポジトリにだけ配布

## ディレクトリ構成

| パス                                                             | 役割                                                                                                                           |
| ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| [settings.json](settings.json)                                   | **ユーザー設定**: 全プロジェクト共通（hooks, sandbox, language）。`~/.claude/settings.json` にシンボリックリンク               |
| [.claude/settings.template.json](.claude/settings.template.json) | **プロジェクト設定テンプレート**: 各プロジェクトの `.claude/settings.json` に配置する雛形（permissions, ask, format フック等） |
| [install.sh](install.sh)                                         | リモート実行用インストーラ（`list` / `add` / `remove`）                                                                        |
| [registry.json](registry.json)                                   | 利用可能な pack の一覧                                                                                                         |
| [skills/](skills/)                                               | 全 skill の実体                                                                                                                |
| [agents/](agents/)                                               | 全 agent の実体                                                                                                                |
| [rules/](rules/)                                                 | 全 rule の実体                                                                                                                 |
| [packs/github-toolkit/](packs/github-toolkit/)                   | PR/Issue 作成・解決・レビュー一式（pack.json / settings.json / README.md）                                                     |
| [packs/docs-toolkit/](packs/docs-toolkit/)                       | 要件→基本→詳細→開発ガイド作成とドキュメントレビュー一式（pack.json / settings.json / README.md）                               |

各 pack は `pack.json` に「含めるファイル一覧」を、`settings.json` に「追加で merge する設定」を持つメタ情報だけを保持する。実体は上記 `skills/` / `agents/` / `rules/` にフラット配置され、複数 pack で同じファイルを参照できる。

## ユーザー設定 vs プロジェクト設定

|              | ユーザー設定                             | プロジェクト設定（テンプレート）                        |
| ------------ | ---------------------------------------- | ------------------------------------------------------- |
| **ファイル** | `settings.json`                          | `.claude/settings.template.json`                        |
| **配置先**   | `~/.claude/settings.json`                | 対象プロジェクトの `.claude/settings.json`              |
| **スコープ** | 全プロジェクト共通                       | プロジェクトごとにカスタマイズ                          |
| **含む内容** | 環境固有（言語、通知音、サンドボックス） | プロジェクト固有（permissions, ask ルール, hooks など） |
| **配布方法** | シンボリックリンク（一度だけ）           | コピーして各プロジェクトで使う                          |

両方の設定はマージされる（スカラーは優先度の高い方で上書き、配列は連結）。`deny` などの制限はユーザー設定に書くと全プロジェクトに効くが、プロジェクト側で外せない（連結のみ）ので注意。

## ユーザー設定のセットアップ

```bash
ln -s ~/dotclaude/settings.json ~/.claude/settings.json
```

## 個別の skill / agent をホームディレクトリに常駐させる

特定の skill（あるいは agent）をどのリポジトリでも使えるようにしたい場合は、`~/.claude/skills/` 配下にシンボリックリンクを貼る。

```bash
ln -s ~/dotclaude/skills/empirical-prompt-tuning ~/.claude/skills/empirical-prompt-tuning
```

agent も同様に `~/.claude/agents/` にリンクする。pack 単位ではなく単体で配りたいケース向け。

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

`install.sh` は `bash` / `git` / `jq` を利用する（macOS / 一般的な Linux で標準）。リモート取得時は `git clone --depth 1` で一度だけリポジトリを取得する。

## ローカル開発

公開前のパッケージを試す場合：

```bash
DOTCLAUDE_SOURCE=/path/to/dotclaude bash install.sh add github-toolkit
```
