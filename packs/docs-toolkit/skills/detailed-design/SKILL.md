---
name: detailed-design
description: 詳細設計書を作成する。「詳細設計」と言われた時、または/setup-projectのステップ3で使用。要件定義書と基本設計書が前提。docs/detailed-design.mdに出力。
---

# 詳細設計書作成スキル

高品質な詳細設計書を作成するためのスキルです。

## 前提条件

- **必須**: `docs/requirements.md`（要件定義書）が作成されている
- **必須**: `docs/basic-design.md`（基本設計書）が作成されている

詳細設計書は、基本設計書で定義されたアーキテクチャに基づき、
各機能の実装レベルの設計を詳細化します。

## 出力ルール

`../rules/document-generation-guide.md` を参照。

**対象ファイル**: `docs/detailed-design.md`

## 参照ファイル

- **テンプレート**: `./assets/template.md`
- **作成ガイド**: `./references/guide.md`

## トラブルシューティング

- **前提ドキュメントが不足**: `docs/requirements.md` と `docs/basic-design.md` が必要です。不足している場合は先に作成してください。
- **既存の設計書との競合**: `../rules/document-generation-guide.md` の優先順位ルールに従ってください。
