# Setup instructions

## Common

### Doing Symbolic Links

#### Windows

Note that this needs to be done on a:
* **`cmd.exe`** terminal
* with **Admin** privileges.

File:

```sh
mklink <final-file> <repo-file>
```

Folder:

```sh
mklink /D <final-folder> <repo-folder>
```

#### Unix

```sh
ln -s <repo-file> <final-file>`
```

## 01 - Core

### Wezterm

#### Install

1. Download wezterm from: https://wezfurlong.org/wezterm/installation.html
2. Install 'Cascadia Code' from: https://github.com/microsoft/cascadia-code/releases
3. Install 'Inter' from: https://fonts.google.com/specimen/Inter

#### Config

* Link `~/.config/wezterm/wezterm.lua` -> `files/wezterm/wezterm.lua`

(Note: On Windows, don't use `/AppData/` for wezterm. We literally meant `C:\Users\<name>\.config\wezterm\wezterm.lua`.)

(Note 2: wezterm watcher may not work on Windows, remember to restart app.)

### Package Manager

* Windows: https://scoop.sh/
* macOS: https://brew.sh/
    * Check requirements at: https://docs.brew.sh/Installation
    * Most notably, require build tools:
```sh
xcode-select --install
```

* Ubuntu: N.A.

### Git

#### Install

* Windows: https://git-scm.com/download/win
* macOS:

```sh
brew install git
```

* Ubuntu:

```sh
sudo add-apt-repository ppa:git-core/ppa
sudo apt update
sudo apt install git
```

Source: https://git-scm.com/downloads

## 02 - Shell

### Powershell

* Windows: Instructions from https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.5

```sh
# Install Powershell 7, which install pwsh.exe
winget install --id Microsoft.PowerShell --source winget
```
* macOS: N.A.
* Linux: N.A.

### Fish shell

#### Install

* Windows: N.A.
* macOS:

```sh
brew install fish
```

* Ubuntu:

```sh
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish
```

Source:
* https://fishshell.com/

#### Config

Append the following to `~/.config/fish/config.fish` to show git info:

```fish
set __fish_git_prompt_show_informative_status 1
```

For macOS, wezterm requires an additional step to expose `wezterm` as a cli command. See instructions at https://wezfurlong.org/wezterm/install/macos.html for more details. The basic detail is to add this to the config:

```fish
set -gx PATH "/Applications/WezTerm.app/Contents/MacOS" $PATH
```

## 03 - Languages

### Clang

* Windows: Use VS installer (see https://learn.microsoft.com/en-us/cpp/build/clang-support-msbuild?view=msvc-170#install-1)
* macOS: N.A. (we already installed when setting up Homebrew).
* Ubuntu:

```sh
sudo apt install build-essential clang
```

#### Config

For Windows, setting up `PATH` is essential so that some tools (e.g. treesitter plugin in neovim) can access clang. For more details, see [Treesitter Wiki](https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support) ("Through Visual Studio")

For other OS, no config is required.

### Rust

#### Install

* Windows: Download from https://www.rust-lang.org/tools/install.
* Unix:

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Source:
* https://www.rust-lang.org/tools/install
* https://forge.rust-lang.org/infra/other-installation-methods.html

#### Config

For fish shell, append the following to `~/.config/fish/config.fish`:

```fish
set -gx PATH "$HOME/.cargo/bin" $PATH
```

### fnm (node, yarn, ...)

#### Install

* Windows

```sh
scoop install fnm
fnm i <put-version-here>
```

* Unix:

```sh
curl -fsSL https://fnm.vercel.app/install | bash
fnm i <put-version-here>
```

Source:
* https://docs.volta.sh/guide/getting-started

#### Config

* Powershell (Windows): Create `~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`:

```ps
fnm env --use-on-cd | Out-String | Invoke-Expression
```

* Fish:
For fish shell, create the file `~/.config/fish/conf.d/fnm.fish`, then add:

```fish
fnm env --use-on-cd --shell fish | source
```

### Golang

#### Install

Download from https://go.dev/doc/install, follow webpage instructions.

#### Config

For fish shell, append the following to `~/.config/fish/config.fish`:

```fish
set -gx PATH $PATH "/usr/local/go/bin"
```

## 04 - Neovim

Follow the instructions in https://github.com/yamgent/mynvim/blob/main/docs/setup.md

## 05 - Other dotfiles

### Gitui

#### Install

```sh
cargo install gitui
```

#### Config

* Windows: Link `~/AppData/Roaming/gitui/key_bindings.ron` -> `files/gitui/key_bindings.ron`
* Unix: Link `~/.config/gitui/key_bindings.ron` -> `files/gitui/key_bindings.ron`

### Tmux

#### Install

* Windows: N.A.
* macOS:

```sh
brew install tmux
```

* Ubuntu:

```sh
sudo apt install tmux
```

#### Config

* Windows: N.A.
* Unix:
    * Link: `~/.tmux.conf` -> `files/tmux/.tmux.conf`
    * Link: `~/.config/tmux/statusline.conf` -> `files/tmux/tmux/statusline.conf`
    * Link: `~/.config/tmux/macos.conf` -> `files/tmux/tmux/macos.conf`

## 06 - Others

### Starship

#### Install

```sh
cargo install starship --locked

# or alternatively, if dependencies are missing
curl -sS https://starship.rs/install.sh | sh
```

#### Config

* Powershell (Windows): Create `~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`:

```ps
Invoke-Expression (&starship init powershell)
```

* Fish: Add to `~/.config/fish/config.fish`:

```sh
starship init fish | source
```

Source: https://starship.rs/

### Extras Utils

* bat
    * `cargo install --locked bat`
* exa
    * `cargo install exa`
* delta
    * `cargo install git-delta`

### Optional Utils

* jq
* dust
* procs
* duf
