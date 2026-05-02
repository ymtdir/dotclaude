# GitHub CLI (`gh`) の使い方

`gh` コマンドは必ず `env -u GITHUB_TOKEN` を前置して実行する。

## 理由

実行環境に `GITHUB_TOKEN` 環境変数が自動注入されており、これが期限切れのため `gh` 標準の認証フローが失敗する。`env -u GITHUB_TOKEN` で当該変数を一時的に外すと、`gh auth login` でキーリングに保存された有効なトークンが使われるようになる。

## 適用範囲

- `gh` のすべてのサブコマンド（`gh issue` / `gh pr` / `gh api` / `gh repo` / `gh auth` など）。
- パイプ・コマンド置換・ワンライナーに含まれる `gh` も同様。`gh` の直前ごとに `env -u GITHUB_TOKEN` を置く（コマンド全体を一回包むのではなく、`gh` 単位で前置する）。
- 認証管理コマンド（`gh auth login` / `gh auth status` 等）にも同じ規則を適用する。

## 実行例

```bash
# OK
env -u GITHUB_TOKEN gh issue view 4
env -u GITHUB_TOKEN gh issue list --state open
env -u GITHUB_TOKEN gh pr create --title "..." --body "..."
env -u GITHUB_TOKEN gh auth status

# コマンド置換でも同様
URL=$(env -u GITHUB_TOKEN gh issue create --title "..." --body "...")

# NG（GITHUB_TOKEN が優先されて認証エラー）
gh issue view 4
```

## トラブルシューティング

| 症状                        | 原因                               | 対処                                                      |
| --------------------------- | ---------------------------------- | --------------------------------------------------------- |
| `gh` が認証エラーで失敗する | `env -u GITHUB_TOKEN` を付け忘れた | 当該コマンドの `gh` 直前に `env -u GITHUB_TOKEN` を付ける |
| 前置しても認証エラーが続く  | キーリング側のトークンが失効済み   | `env -u GITHUB_TOKEN gh auth login` で再認証              |
