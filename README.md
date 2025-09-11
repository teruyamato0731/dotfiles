<div align="center">

# dotfiles

***My dotfiles for Ubuntu 24.04 LTS.***

[![Open in Dev Containers](https://img.shields.io/static/v1?label=Dev%20Containers&message=Open&color=blue&logo=visualstudiocode)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/teruyamato0731/dotfiles)
[![Ubuntu 24.04](https://img.shields.io/badge/Ubuntu%2024.04-orange?logo=ubuntu&logoColor=white
)](https://releases.ubuntu.com/noble/)
[![license](https://img.shields.io/github/license/teruyamato0731/dotfiles)](https://github.com/teruyamato0731/dotfiles/blob/main/LICENSE)
[![CI](https://github.com/teruyamato0731/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/teruyamato0731/dotfiles/actions/workflows/ci.yml)

</div>

## Installation

<details><summary>Prerequisites</summary>

- `bash`
- `sudo`
- `apt-get`
- `git` or `curl`

</details>

Clone the repo and run the installer:

```bash
git clone https://github.com/teruyamato0731/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

Or use the one-liner:

```bash
DOTFILES_DIR="$HOME/dotfiles" bash <(curl -fsSL https://raw.githubusercontent.com/teruyamato0731/dotfiles/main/install.sh)
```

## インストールされるツールと機能

### CLIツールとユーティリティ

このdotfilesリポジトリは、以下の便利なCLIツールとユーティリティを自動的にインストールします：

#### 基本ツール
- **bash-completion** - Bashの補完機能を強化
- **git** - バージョン管理システム
- **curl** - データ転送ツール
- **unzip** - アーカイブ展開ツール
- **tree** - ディレクトリ構造の可視化
- **htop** - 対話型プロセスビューア
- **jq** - JSONプロセッサ

#### 高機能な代替ツール
- **bat** - シンタックスハイライト付きの`cat`代替（`batcat` → `bat`へのシンボリックリンク作成）
- **ripgrep** - 高速な`grep`代替
- **fd-find** - 高速な`find`代替（`fdfind` → `fd`へのシンボリックリンク作成）
- **gh** - GitHub CLI

#### 開発支援ツール
- **ghq** (v1.8.0) - Gitリポジトリの統一管理ツール
- **fzf** - 高速なファジーファインダー
- **fzf-git.sh** - fzfのGit統合拡張

### カスタム設定とエイリアス

#### Bash設定 (`.bashrc.custom`)
- **プロンプト強化**: Gitブランチとステータスを表示するPS1
- **便利なエイリアス**:
  - `ls` → カラー表示有効
  - `grep` → カラー表示有効  
  - `ll` → `ls -alF`
  - `cat` → `bat --paging=never`

#### 高度なfzf統合
- **環境変数設定**: プレビュー機能付きの検索
- **カスタム関数**:
  - `gcd()` - ghqリポジトリをfzfで選択してcd
  - `gsw()` - Gitブランチをfzfで選択してswitch  
  - `batdiff()` - Git差分をbatで表示
- **キーバインド**:
  - `Ctrl+O` - gcd関数実行
  - `Ctrl+_` - gsw関数実行

#### Git設定 (`.gitconfig.custom`)
- **エディタ**: VS Code (`code --wait`)
- **便利なエイリアス**:
  - `aliases` - 設定済みエイリアス一覧表示
  - `amend` - 直前のコミットを修正
  - `graph` - グラフィカルなログ表示
  - `fixup` - fzfでコミット選択してfixup
  - `ss` / `sp` - stash push/pop
  - `undo` - 直前のコミットを取り消し
- **コミットテンプレート**: Conventional Commitsフォーマット

#### C++開発設定 (`.clang-format`)
- **ベーススタイル**: Google Style
- **C++17標準**対応
- **カラム制限**: 120文字
- **カスタマイズ**: 日本語コメント対応、インデント設定など

### 開発環境統合

#### VS Code Dev Containers対応
- **自動セットアップ**: `.devcontainer`設定済み
- **統合サポート**: VS Code設定でdotfilesを自動適用可能

#### ディレクトリ構造管理
- **ghq統合**: `$(ghq root)/github.com/teruyamato0731/dotfiles`へのシンボリックリンク
- **設定ファイル**: `~/.gitconfig.custom`と`~/.bashrc.custom`へのシンボリックリンク
- **自動読み込み**: `~/.bashrc`にカスタム設定の読み込みを追加

## Try with Dev Containers

To use Dev Containers, first install the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension for VS Code.

Then, open the command palette (Ctrl+Shift+P) and select **Dev Containers: Open Workspace in Container...**.

```bash
git clone https://github.com/teruyamato0731/dotfiles.git ~/dotfiles
code --install-extension ms-vscode-remote.remote-containers
code ~/dotfiles
```

<details><summary>Try on Docker Container</summary>

You can try it on a Docker container as follows:

```bash
docker run --rm -it ubuntu:24.04 bash
apt-get update && apt-get install -y curl
DOTFILES_DIR="$HOME/dotfiles" bash <(curl -fsSL https://raw.githubusercontent.com/teruyamato0731/dotfiles/main/install.sh)
```

</details>

<details><summary>Apply to all Dev Containers</summary>

To have these dotfiles applied automatically inside every VS Code Dev Container you open, add the following to your VS Code user settings (Open Settings → Open Settings (JSON)):

```json
{
    "dotfiles.repository": "https://github.com/teruyamato0731/dotfiles.git",
    "dotfiles.installCommand": "./install.sh",
    "dotfiles.targetPath": "~/dotfiles"
},
```

</details>
