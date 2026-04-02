# ドキュメント生成ガイド

ドキュメント生成スキル（prd-writing, functional-design, architecture-design, repository-structure, development-guidelines, glossary-creation）で、メインドキュメントを生成する際のフォーマット・制約について定めます。

## 出力制約

各スキルのメインドキュメントは以下の制約に従ってください：

- **行数制限**: 300-400行以内でコンパクトにまとめる
- **詳細情報の配置**: 詳細が必要な場合は、メインドキュメント内で参照情報を記載し、別ファイルを作成するよう指示する

## 例

### docs/product-requirements.md (300-400行以内)

```markdown
## 主要機能

- 機能A
- 機能B

詳細な機能要件・受け入れ条件は `docs/requirements/` を参照してください。
```

## メインドキュメント一覧

メインファイル名は変わりません：

```
docs/product-requirements.md
docs/functional-design.md
docs/architecture.md
docs/repository-structure.md
docs/development-guidelines.md
docs/glossary.md
```

## 詳細ドキュメント

詳細が必要な場合は、以下のように補足ドキュメントを作成します：

```
docs/requirements/features.md
docs/requirements/acceptance-criteria.md

docs/architecture/infrastructure.md
docs/architecture/api-design.md

docs/guidelines/implementation-patterns.md
```

メインドキュメント内で「詳細は `docs/[サブディレクトリ]/` を参照」と記載してください。
