# shared/

複数の pack で共通して使うファイルの実体置き場。pack 側からは `pack.json` の `shared[]` で参照する。

## なぜ必要か

`commit-conventions.md` のように複数 pack で必要なルールを各 pack に複製すると、片方を更新したときに他方と差分が発生し、`install.sh` が「同名で内容が違う」警告を出すことになる。`packs/shared/` に実体を 1 つだけ置いておけば、どの pack をインストールしても対象リポの `.claude/rules/commit-conventions.md` は常に 1 ファイル・同一内容に収束する。

## 現在の中身

| パス                                 | 用途                                                           |
| ------------------------------------ | -------------------------------------------------------------- |
| `packs/shared/rules/commit-conventions.md` | コミットメッセージ規約（github-toolkit / docs-toolkit が参照） |

## 追加方法

1. 共通化したいファイルを `packs/shared/<同じ展開先パス>` に置く（例: `packs/shared/rules/foo.md` → 展開先 `.claude/rules/foo.md`）
2. 参照したい pack の `pack.json` の `shared[]` に `"rules/foo.md"` を追加
