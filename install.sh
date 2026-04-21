#!/usr/bin/env bash
# dotclaude installer
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/ymtdir/dotclaude/main/install.sh | bash -s -- list
#   curl -fsSL https://raw.githubusercontent.com/ymtdir/dotclaude/main/install.sh | bash -s -- add <pack> [--ref <ref>] [--force]
#   curl -fsSL https://raw.githubusercontent.com/ymtdir/dotclaude/main/install.sh | bash -s -- remove <pack>
#
# Local dev:
#   DOTCLAUDE_SOURCE=/path/to/dotclaude bash install.sh list

set -euo pipefail

REPO="${DOTCLAUDE_REPO:-ymtdir/dotclaude}"
REF="${DOTCLAUDE_REF:-main}"
SOURCE="${DOTCLAUDE_SOURCE:-}"
FORCE="${DOTCLAUDE_FORCE:-0}"
DEST_ROOT="${DOTCLAUDE_DEST:-$PWD}"
CLAUDE_DIR="${DEST_ROOT}/.claude"
MANIFEST="${CLAUDE_DIR}/.dotclaude-manifest.json"
SETTINGS="${CLAUDE_DIR}/settings.json"

die() { echo "error: $*" >&2; exit 1; }
info() { echo "$*" >&2; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "'$1' is required but not installed"
}

require_cmd jq

ensure_source() {
  [[ -n "$SOURCE" ]] && return 0
  require_cmd git
  SOURCE="$(mktemp -d)"
  trap 'rm -rf "$SOURCE"' EXIT
  info "fetching ${REPO}@${REF}..."
  git clone --depth 1 --branch "$REF" "https://github.com/${REPO}.git" "$SOURCE" >/dev/null 2>&1 \
    || die "failed to clone https://github.com/${REPO}.git (ref: ${REF})"
}

# fetch <relative-path>  →  stdout（無ければ空）
fetch() {
  local rel="$1"
  [[ -f "$SOURCE/$rel" ]] && cat "$SOURCE/$rel" || true
}

fetch_required() {
  local rel="$1" out
  out="$(fetch "$rel")"
  [[ -n "$out" ]] || die "could not fetch ${rel}"
  printf '%s' "$out"
}

fetch_dir() {
  local rel="$1" dest="$2"
  [[ -d "$SOURCE/$rel" ]] || die "directory not found in source: ${rel}"
  mkdir -p "$(dirname "$dest")"
  cp -R "$SOURCE/$rel" "$dest"
}

fetch_file() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  fetch_required "$src" > "$dest"
}

# ─── manifest helpers ────────────────────────────────────────────
# 構造:
# {
#   "base_settings": {...},          # pack 一切なしの状態の settings 全体
#   "packs": {
#     "<name>": {
#       "files": [...],
#       "settings": {...}            # pack 由来の settings 全体
#     }
#   }
# }

manifest_init() {
  mkdir -p "$CLAUDE_DIR"
  [[ -f "$MANIFEST" ]] || echo '{"packs":{}}' > "$MANIFEST"
}

manifest_get_files() {
  local pack="$1"
  jq -r --arg p "$pack" '.packs[$p].files // [] | .[]' "$MANIFEST"
}

manifest_set_pack() {
  local pack="$1" files_json="$2" settings_json="$3" updated
  updated="$(jq --arg p "$pack" --argjson f "$files_json" --argjson s "$settings_json" \
    '.packs[$p] = {files: $f, settings: $s}' "$MANIFEST")"
  printf '%s\n' "$updated" > "$MANIFEST"
}

manifest_remove_pack() {
  local pack="$1" updated
  updated="$(jq --arg p "$pack" 'del(.packs[$p])' "$MANIFEST")"
  printf '%s\n' "$updated" > "$MANIFEST"
}

file_is_orphan() {
  local rel="$1" count
  count=$(jq -r --arg f "$rel" '[.packs[].files[]? | select(. == $f)] | length' "$MANIFEST")
  [[ "$count" == "0" ]]
}

# base_settings がまだ無ければ現在の settings.json を取り込む
manifest_capture_base_if_absent() {
  local has_base
  has_base=$(jq 'has("base_settings")' "$MANIFEST")
  if [[ "$has_base" == "false" ]]; then
    local base
    if [[ -f "$SETTINGS" ]]; then
      base="$(cat "$SETTINGS")"
    else
      base='{}'
    fi
    local updated
    updated="$(jq --argjson b "$base" '.base_settings = $b' "$MANIFEST")"
    printf '%s\n' "$updated" > "$MANIFEST"
  fi
}

# ─── deep merge (jq) ─────────────────────────────────────────────
# 配列: union (unique)、オブジェクト: 再帰、スカラー: pack 側で上書き
JQ_DEEP_MERGE='
def deep_merge($a; $b):
  if   ($a | type) == "object" and ($b | type) == "object" then
    reduce ($a + $b | keys_unsorted | unique)[] as $k
      ({}; .[$k] = (
        if   ($a | has($k)) and ($b | has($k)) then deep_merge($a[$k]; $b[$k])
        elif ($b | has($k)) then $b[$k]
        else $a[$k] end
      ))
  elif ($a | type) == "array" and ($b | type) == "array" then
    ($a + $b) | unique
  elif $b == null then $a
  else $b
  end;
'

# ─── settings.json 再構築 ────────────────────────────────────────
# base_settings に全 active pack の settings を順次 deep-merge して書き出す
rebuild_settings() {
  mkdir -p "$CLAUDE_DIR"
  local result
  result="$(jq "${JQ_DEEP_MERGE} reduce (.packs[].settings // {}) as \$s (.base_settings // {}; deep_merge(.; \$s))" "$MANIFEST")"
  if [[ "$result" == "{}" ]]; then
    rm -f "$SETTINGS"
  else
    printf '%s\n' "$result" > "$SETTINGS"
  fi
}

# ─── commands ────────────────────────────────────────────────────

cmd_list() {
  ensure_source
  local registry
  registry="$(fetch_required registry.json)"
  echo "$registry" | jq -r '.packs[] | "\(.name)\t\(.description)"' | column -t -s $'\t'
}

# expand_targets <pack-path> → 行ごと "kind\tsrc_rel\tdest_rel"
expand_targets() {
  local pack_path="$1" pack_json
  pack_json="$(fetch_required "${pack_path}/pack.json")"
  echo "$pack_json" | jq -r '.files[]?' | while read -r entry; do
    if [[ "$entry" == */ ]]; then
      echo -e "dir\t${entry%/}\t${entry%/}"
    else
      echo -e "file\t${entry}\t${entry}"
    fi
  done
}

cmd_add() {
  ensure_source
  local pack="$1"
  local registry pack_path
  registry="$(fetch_required registry.json)"
  pack_path="$(echo "$registry" | jq -r --arg p "$pack" '.packs[] | select(.name == $p) | .path')"
  [[ -n "$pack_path" ]] || die "pack '$pack' not found in registry"

  manifest_init
  manifest_capture_base_if_absent

  # 1) ファイル展開
  local installed_files=()
  while IFS=$'\t' read -r kind src dest; do
    local target="${CLAUDE_DIR}/${dest}"
    if [[ -e "$target" && "$FORCE" != "1" ]]; then
      info "skip (exists): .claude/${dest}  (use --force to overwrite)"
    else
      case "$kind" in
        file)   fetch_file "${src}" "$target" ;;
        dir)    fetch_dir  "${src}" "$target" ;;
      esac
      info "added: .claude/${dest}"
    fi
    installed_files+=("$dest")
  done < <(expand_targets "$pack_path")

  # 2) pack settings を取り込み manifest に記録
  local pack_settings
  pack_settings="$(fetch "${pack_path}/settings.json")"
  [[ -n "$pack_settings" ]] || pack_settings='{}'

  local files_json
  files_json=$(printf '%s\n' "${installed_files[@]}" | jq -R . | jq -s .)
  manifest_set_pack "$pack" "$files_json" "$pack_settings"

  # 3) settings.json を再構築
  rebuild_settings
  info "✓ installed pack '$pack' into ${CLAUDE_DIR}"
}

cmd_remove() {
  local pack="$1"
  [[ -f "$MANIFEST" ]] || die "no manifest at $MANIFEST"

  local files=()
  while IFS= read -r line; do [[ -n "$line" ]] && files+=("$line"); done < <(manifest_get_files "$pack")
  [[ ${#files[@]} -gt 0 ]] || die "pack '$pack' is not installed"

  manifest_remove_pack "$pack"

  for rel in "${files[@]}"; do
    if file_is_orphan "$rel"; then
      local target="${CLAUDE_DIR}/${rel}"
      if [[ -d "$target" ]]; then rm -rf "$target"; else rm -f "$target"; fi
      info "removed: .claude/${rel}"
    else
      info "kept (still used by another pack): .claude/${rel}"
    fi
  done

  rebuild_settings
  info "✓ removed pack '$pack'"
}

usage() {
  cat <<EOF
dotclaude installer

Commands:
  list                       List available packs
  add <pack> [--force]       Install a pack into <cwd>/.claude/
  remove <pack>              Uninstall a pack (uses manifest)

Env:
  DOTCLAUDE_SOURCE=<path>    Use a local checkout instead of GitHub
  DOTCLAUDE_REPO=<owner/r>   Override repo (default: ymtdir/dotclaude)
  DOTCLAUDE_REF=<branch|tag> Override ref (default: main)
EOF
}

main() {
  [[ $# -ge 1 ]] || { usage; exit 1; }
  local sub="$1"; shift
  case "$sub" in
    list) cmd_list ;;
    add)
      [[ $# -ge 1 ]] || die "add: pack name required"
      local pack="$1"; shift
      while [[ $# -gt 0 ]]; do
        case "$1" in
          --force) FORCE=1 ;;
          --ref)   REF="$2"; shift ;;
          *) die "unknown option: $1" ;;
        esac
        shift
      done
      cmd_add "$pack"
      ;;
    remove)
      [[ $# -ge 1 ]] || die "remove: pack name required"
      cmd_remove "$1"
      ;;
    -h|--help|help) usage ;;
    *) usage; exit 1 ;;
  esac
}

main "$@"
