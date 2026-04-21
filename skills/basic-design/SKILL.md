---
name: basic-design
description: 基本設計書を作成する。「基本設計」と言われた時、または/setup-projectのステップ2で使用。要件定義書が前提。docs/basic-design.mdに出力。
---

# 基本設計書作成スキル

高品質な基本設計書を作成するためのスキルです。

## 前提条件

- **必須**: `docs/requirements.md`（要件定義書）が作成されている

基本設計書は、要件定義書の要件を技術的に実現するための
システム構造とテクノロジースタックを定義します。

## 出力ルール

`../../rules/document-generation-guide.md` を参照。

**対象ファイル**: `docs/basic-design.md`

## 参照ファイル

- **テンプレート**: `./assets/template.md`
- **作成ガイド**: `./references/guide.md`

## トラブルシューティング

- **前提ドキュメントが不足**: `docs/requirements.md` が必要です。不足している場合は先に作成してください。
- **既存の設計書との競合**: `../../rules/document-generation-guide.md` の優先順位ルールに従ってください。
