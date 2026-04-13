---
name: development-guide
description: 開発ガイドライン（リポジトリ構造・コーディング規約・用語集）を作成する。「開発ガイドライン」「リポジトリ構造」「コーディング規約」「用語集」と言われた時、または/setup-projectのステップ4で使用。docs/development-guide.mdに出力。
---

# 開発ガイドライン作成スキル

高品質な開発ガイドラインを作成するためのスキルです。

## 前提条件

- **必須**: `docs/requirements.md`（要件定義書）が作成されている
- **必須**: `docs/basic-design.md`（基本設計書）が作成されている
- **必須**: `docs/detailed-design.md`（詳細設計書）が作成されている

開発ガイドラインは、上記3ドキュメントの内容を元に、
具体的なリポジトリ構造・開発ルール・プロジェクト用語を定義します。

## 出力ルール

`../rules/document-generation-guide.md` を参照。

**対象ファイル**: `docs/development-guide.md`

## 参照ファイル

- **テンプレート**: `./assets/template.md`

### リポジトリ構造

- ガイド: `./references/structure-guide.md`

### 開発ガイドライン

- 実装ガイド: `./references/implementation-guide.md`
- プロセスガイド: `./references/process-guide.md`

### 用語集

- ガイド: `./references/glossary-guide.md`

## トラブルシューティング

- **前提ドキュメントが不足**: 要件定義書・基本設計書・詳細設計書が必要です。不足している場合は先に作成してください。
- **既存のガイドとの競合**: `../rules/document-generation-guide.md` の優先順位ルールに従ってください。
