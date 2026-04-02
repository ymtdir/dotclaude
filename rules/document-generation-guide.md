# ドキュメント生成ガイド

ドキュメント生成スキル（requirements-definition, basic-design, detailed-design, development-guide）で、メインドキュメントを生成する際のフォーマット・制約について定めます。

## 既存ドキュメントの優先順位

`docs/` に既存ドキュメントがある場合、以下の優先順位に従ってください:

1. **既存のドキュメント (`docs/[ファイル名].md`)** - 最優先
   - プロジェクト固有の要件が記載されている
   - このスキルのガイドより優先する

2. **このスキルのガイド** - 参考資料
   - 汎用的なテンプレートと例
   - 既存ドキュメントがない場合、または補足として使用

### 新規作成時と更新時の使い分け

- **新規作成時**: スキルのテンプレート（`./assets/template.md`）とガイド（`./references/guide.md`）を参照
- **更新時**: 既存ドキュメントの構造と内容を維持しながら更新

## 出力制約

各スキルのメインドキュメントは以下の制約に従ってください：

- **行数制限**: 300-400行以内でコンパクトにまとめる
- **詳細情報の配置**: 詳細が必要な場合は、メインドキュメント内で参照先を記載し、サブディレクトリに別ファイルを作成する

```markdown
# 例: docs/requirements.md 内での参照

## 主要機能

- 機能A
- 機能B

詳細な機能要件・受け入れ条件は `docs/requirements/` を参照してください。
```

## メインドキュメント

```
docs/requirements.md       # 要件定義書
docs/basic-design.md       # 基本設計書
docs/detailed-design.md    # 詳細設計書
docs/development-guide.md  # 開発ガイドライン
```

## 補足ドキュメント

300-400行に収まらない詳細は、サブディレクトリに分割します：

```
docs/requirements/features.md
docs/requirements/acceptance-criteria.md

docs/design/infrastructure.md
docs/design/api-design.md

docs/guide/implementation-patterns.md
```

メインドキュメント内で「詳細は `docs/[サブディレクトリ]/` を参照」と記載してください。
