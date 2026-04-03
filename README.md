# dotclaude

## 概要

Claude Code の設定ファイルを管理するリポジトリです。

セットアップは必要なファイル・フォルダのシンボリックリンクを個別に貼る方式を採用しています。

## シンボリックリンク

### settings.json

```bash
ln -s ~/dotclaude/settings.json ~/.claude/settings.json
```

### agents

```bash
ln -s ~/dotclaude/agents ~/.claude/agents
```

### commands

```bash
ln -s ~/dotclaude/commands ~/.claude/commands
```

### rules

```bash
ln -s ~/dotclaude/rules ~/.claude/rules
```

### skills

```bash
ln -s ~/dotclaude/skills ~/.claude/skills
```
