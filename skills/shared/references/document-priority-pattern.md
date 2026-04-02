# ドキュメント優先順位パターン

このパターンはドキュメント作成スキル（prd-writing, functional-design, architecture-design, repository-structure, development-guidelines, glossary-creation）で共通して適用されるルールです。

## 優先順位ルール

`docs/` に既存ドキュメントがある場合、以下の優先順位に従ってください:

1. **既存のドキュメント (`docs/[ファイル名].md`)** - 最優先
   - プロジェクト固有の要件が記載されている
   - このスキルのガイドより優先する

2. **このスキルのガイド** - 参考資料
   - 汎用的なテンプレートと例
   - 既存ドキュメントがない場合、または補足として使用

## 使い分け

- **新規作成時**: スキルのテンプレート（`./assets/template.md`）とガイド（`./references/guide.md`）を参照
- **更新時**: 既存ドキュメントの構造と内容を維持しながら更新
