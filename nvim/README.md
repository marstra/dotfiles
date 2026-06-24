# Neovim Setup (LazyVim-based)

A LazyVim config tuned for:
- **Code review** — Copilot CLI session diffs, GitHub PRs from colleagues
- **Git** — handcrafted commits, hunk-level staging
- **Java/Spring Boot** + **Angular/TypeScript** LSP
- **GitHub Copilot** — autocomplete + interactive chat
- **WSL2** on Windows (DATEV/corporate environment)

> This is your "Spacemacs for neovim": LazyVim provides the opinionated base,
> `lua/plugins/` contains your layers (extras), same mental model as `.spacemacs.d`.

---

## Quick Start (5 minutes)

### 1 — Prerequisites

```bash
# Neovim ≥ 0.11.2 (Ubuntu apt ships an ancient version — use AppImage)
mkdir -p ~/.local/bin
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod +x nvim-linux-x86_64.appimage && mv nvim-linux-x86_64.appimage ~/.local/bin/nvim

# lazygit (git TUI, used by <leader>gg)
LGVER=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep '"tag_name"' | grep -Po '[\d.]+')
curl -Lo /tmp/lg.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LGVER}_Linux_x86_64.tar.gz"
tar xf /tmp/lg.tar.gz -C ~/.local/bin lazygit

# win32yank — WSL2 clipboard bridge
curl -sLo /tmp/w32y.zip https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip
unzip -p /tmp/w32y.zip win32yank.exe > ~/.local/bin/win32yank.exe && chmod +x ~/.local/bin/win32yank.exe

# C compiler for treesitter (already present in DATEV WSL image via build-essential)
# Check: gcc --version

# Verify ~/.local/bin is in PATH (it should be via .zshenv)
echo $PATH | grep -q local/bin && echo "✓ PATH ok" || echo "⚠ Add ~/.local/bin to PATH in .zshenv"
```

### 2 — Nerd Font in Windows Terminal

LazyVim uses icons from a Nerd Font. In **Windows Terminal → Settings → your WSL profile → Appearance → Font face** set it to one of:
- `JetBrainsMono Nerd Font` ← recommended
- `CaskaydiaCove Nerd Font` (Cascadia Code variant)

Download from [nerdfonts.com](https://www.nerdfonts.com/font-downloads), install on Windows (double-click the TTF).

### 3 — Symlink the config

```bash
# Link dotfiles/nvim → ~/.config/nvim  (same pattern as vim/.vimrc)
mkdir -p ~/.config
ln -s ~/repos/dotfiles/nvim ~/.config/nvim
```

### 4 — First launch

```bash
nvim
```

lazy.nvim auto-installs everything (~2–3 min, one-time). You'll see a progress UI. When it finishes, restart nvim.

### 5 — Install LSP servers

```
:Mason
```

Navigate with arrow keys, press `i` to install:
- `jdtls` — Java language server
- `typescript-language-server` — TypeScript/Angular
- `angular-language-server` — Angular templates

> Mason uses npm + curl under the hood. Your Artifactory npm config handles the npm installs.
> Java's `jdtls` downloads directly from Eclipse — may need proxy: `:echo $https_proxy` inside nvim.

### 6 — Authenticate GitHub (for octo.nvim + CopilotChat)

```bash
gh auth status    # should already be authed from copilot-cli setup
nvim              # then run :Copilot auth  (only if Copilot inline isn't working)
```

---

## File Structure

```
dotfiles/nvim/                  ← symlinked to ~/.config/nvim
├── init.lua                    ← entry point (just loads lazy bootstrap)
├── lua/
│   ├── config/
│   │   ├── lazy.lua            ← lazy.nvim bootstrap + plugin spec
│   │   ├── options.lua         ← vim/neovim options (carried from .vimrc)
│   │   ├── keymaps.lua         ← your custom keymaps
│   │   └── autocmds.lua        ← filetype autocmds (Java 4-space, etc.)
│   └── plugins/
│       ├── extras.lua          ← LazyVim "layers" (java, copilot, octo, …)
│       ├── git.lua             ← neogit + diffview (not in LazyVim core)
│       └── colorscheme.lua     ← gruvbox (your .vimrc theme, Lua port)
└── README.md
```

**To add/remove a "layer":** edit `lua/plugins/extras.lua`, comment/uncomment the import line, save, run `:Lazy sync`.

**To tweak a LazyVim plugin:** create any `lua/plugins/my-tweak.lua` and override opts:
```lua
return {
  { "folke/which-key.nvim", opts = { delay = 500 } },
}
```

---

## Daily Workflows

### Reviewing Copilot CLI session output

After a Copilot CLI session generates changes in a project:

```
<leader>gd      → DiffviewOpen: see ALL changed files vs HEAD side-by-side
]c / [c         → jump next/prev change hunk inside a diff buffer
<leader>gH      → full repo history (pick any commit, browse its diff)
<leader>gh      → current file history
:DiffviewClose  → back to normal (or just <leader>gd again to toggle)
```

The file panel on the left shows all modified files. Select one → split diff opens on right. This is your primary "what did the bot do" view.

### Reviewing a colleague's PR

```
<leader>gp       → Octo pr list  (fuzzy search open PRs)
<Enter>          → open the PR buffer (shows description, comments, reviewers)
:Octo review     → enter review mode (new tab: file panel + diff)
]q / [q          → cycle through changed files
<localleader>ca  → add inline comment on current line
<localleader>sa  → add suggestion (code change)
:Octo review submit → submit review (prompts: comment / approve / request changes)
```

You can also open any PR directly by URL:
```
:Octo https://github.com/your-org/repo/pull/123
```

### Handcrafting commits (two modes)

**Mode A — lazygit** (recommended for most commits):
```
<leader>gg       → open lazygit fullscreen
space            → stage/unstage file
e                → expand to hunk view, stage individual hunks
c                → open commit editor
P                → push
q                → quit lazygit
```

**Mode B — neogit** (Magit muscle memory):
```
<leader>gn       → open Neogit status buffer
Tab              → expand file to see hunks
s / u            → stage / unstage hunk or file
c c              → commit (opens commit message buffer)
c a              → amend last commit
P p              → push to origin
q                → close
```

**Mode C — gitsigns** (quick single-hunk staging without leaving your buffer):
```
]h / [h          → jump next/prev hunk
<leader>hs       → stage hunk under cursor
<leader>hr       → reset (discard) hunk
<leader>hb       → inline git blame for current line
<leader>hp       → preview hunk diff in float
```

### CopilotChat (ask AI about code you're reading)

```
<leader>aa       → toggle CopilotChat panel (40% side panel)
<leader>aq       → quick one-line prompt
<leader>ap       → prompt actions menu (explain, review, fix, …)
```

Visual select code first, then `<leader>aa` → Copilot has that code as context. Great for:
- "Explain this Spring Security filter chain"
- "What does this Angular resolver do?"
- "Spot any issues in this diff"

---

## Onboarding Your Existing Projects

### Backend — Java Spring Boot (`~/working-copies/backend-pr156`)

```bash
cd ~/working-copies/backend-pr156
nvim .
```

On first open of any `.java` file, nvim-jdtls starts the Eclipse JDT Language Server (downloaded on first use by Mason). It detects `pom.xml` automatically.

**Wait ~30 seconds** for JDT to index the project (watch the status line bottom-right). Then:

```
gd              → go to definition
gr              → find all references
K               → hover docs (Javadoc)
<leader>ca      → code actions (organize imports, generate getters, add override…)
<leader>cr      → rename symbol (refactor-safe rename across files)
<leader>cxm     → extract method (visual select first)
<leader>cxv     → extract variable
<leader>cf      → format file (google-java-format via Mason)
<leader>tt      → run test class (requires java-test Mason package)
<leader>tr      → run nearest test method
```

**Spring Boot specific:**
- `pom.xml` autocompletion works via LSP
- Bean navigation: `gd` on `@Autowired` fields jumps to the bean definition
- If you use Lombok: add `lombok` to Mason (`jdtls` supports it with annotation processing)

### Frontend — Angular/TypeScript (`~/working-copies/frontend-pr79`)

```bash
cd ~/working-copies/frontend-pr79
nvim .
```

LSP starts automatically for `.ts` / `.html` files after Mason installs `typescript-language-server` and `angular-language-server`.

```
gd              → go to definition (crosses .ts ↔ .html ↔ .spec.ts boundaries)
K               → hover type info
<leader>ca      → code actions (add missing import, fix lint error)
<leader>cf      → prettier format
]d / [d         → jump next/prev ESLint diagnostic
<leader>xx      → open Trouble panel (all diagnostics in project)
```

**Angular specific:**
- In `.html` templates: component input/output completion, `*ngFor`, `*ngIf` snippets
- `gd` in a template on a component selector jumps to the component `.ts`

---

## Essential Keymap Reference

> `<leader>` = `Space`. Press it and **which-key pops up** showing all options. You don't need to memorise this table — it's here for the first week.

### Navigation

| Key | Action |
|-----|--------|
| `<leader>ff` | Find file (fzf) |
| `<leader>fr` | Recent files |
| `<leader>/` | Live grep in project (ripgrep) |
| `<leader>sg` | Search grep (same as above) |
| `<leader>e` | File explorer (neo-tree) |
| `<leader>be` | Buffer explorer |
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<C-h/j/k/l>` | Move between splits |

### Git

| Key | Action |
|-----|--------|
| `<leader>gg` | lazygit (full TUI) |
| `<leader>gn` | Neogit (Magit) |
| `<leader>gd` | DiffviewOpen (working tree) |
| `<leader>gh` | Repo history (diffview) |
| `<leader>gH` | Current file history |
| `<leader>gp` | List PRs (octo.nvim) |
| `<leader>gP` | Search PRs |
| `<leader>gi` | List issues |
| `]h / [h` | Next/prev git hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hb` | Blame line |

### AI

| Key | Action |
|-----|--------|
| `<Tab>` | Accept Copilot suggestion |
| `<M-]>` | Next Copilot suggestion |
| `<M-[>` | Prev Copilot suggestion |
| `<leader>aa` | Toggle CopilotChat |
| `<leader>aq` | Quick chat prompt |
| `<leader>ap` | Prompt actions menu |

### Code

| Key | Action |
|-----|--------|
| `<leader>ca` | Code action |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format |
| `<leader>xx` | Diagnostics panel (Trouble) |
| `]d / [d` | Next/prev diagnostic |
| `<leader>cs` | Document symbols |

### UI

| Key | Action |
|-----|--------|
| `<leader>gg` | lazygit |
| `<leader>` (wait) | which-key: see ALL keymaps |
| `:Lazy` | Plugin manager UI |
| `:Mason` | LSP/tool installer |
| `:LazyExtras` | Toggle extras interactively |
| `:checkhealth` | Diagnose problems |

---

## Customisation

### Add a new "layer"

Edit `lua/plugins/extras.lua` and add an import. Example — add avante.nvim (Cursor-like AI):
```lua
{ import = "lazyvim.plugins.extras.ai.avante" },
```
Save, then `:Lazy sync`.

See all available extras: https://www.lazyvim.org/extras

### Override a plugin option

Create `lua/plugins/my-tweaks.lua`:
```lua
return {
  -- example: slower which-key popup
  { "folke/which-key.nvim", opts = { delay = 600 } },

  -- example: disable neo-tree, use snacks explorer instead
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  { import = "lazyvim.plugins.extras.editor.snacks_explorer" },
}
```

### Add a completely new plugin

Same file, standard lazy.nvim spec:
```lua
return {
  {
    "someone/some-plugin.nvim",
    event = "BufReadPost",
    opts = { key = "value" },
    keys = {
      { "<leader>X", "<cmd>SomeCommand<cr>", desc = "Do the thing" },
    },
  },
}
```

### Change theme

In `lua/plugins/colorscheme.lua` change the colorscheme name:
```lua
opts = { colorscheme = "tokyonight" },  -- LazyVim default, best plugin support
-- or: "tokyonight-moon", "catppuccin", "rose-pine", "gruvbox"
```

---

## Updating

```bash
# Inside neovim:
:Lazy update      # update all plugins
:Lazy sync        # install missing + update (after editing plugins/)
:Mason            # update LSP servers here separately
```

Lazy auto-checks for updates in the background (no notifications — run `:Lazy` to see the badge).

---

## Troubleshooting

### `:checkhealth` — run this first

Opens a health report. Look for ❌ errors. Common fixes:

| Problem | Fix |
|---------|-----|
| `clipboard: no provider` | Install win32yank: see Quick Start step 1 |
| `nvim version too old` | You're running the apt nvim — use the AppImage |
| `node not found` | `nvm use default` then reopen nvim, or set `node_host_prog` |
| Copilot not working | `:Copilot auth` then follow the device flow |
| jdtls not starting | `:LspInfo` while in a `.java` file; check Mason installed `jdtls` |
| Angular LSP slow | Normal — it indexes the full project on first open |
| Icons missing (squares) | Nerd Font not set in Windows Terminal (see Quick Start step 2) |

### Proxy issues (DATEV corporate network)

lazy.nvim and Mason use `git clone` and `curl`. Your `.gitconfig` proxy settings apply to git clones. For curl (Mason uses it to download LSP binaries):

```bash
# Already set via Artifactory config in your WSL image, but verify:
echo $https_proxy    # should show the DATEV proxy
```

If Mason fails to download something, run `:Mason` → hover over the failing package → `<Enter>` to see the error.

### Java — project not indexing

1. Confirm `pom.xml` is in the project root (it detects project type from it)
2. `:LspInfo` — check jdtls is attached to the buffer
3. `:LspRestart` — restart the language server
4. JDTLS workspace lives in `~/.local/share/nvim/jdtls-workspace/` — delete it and reopen to force a clean index

---

## Next Steps (when ready)

- **avante.nvim** — Cursor AI sidebar in neovim (17k stars, exploding): `{ import = "lazyvim.plugins.extras.ai.avante" }`
- **neotest** — run and navigate test results inline: `{ import = "lazyvim.plugins.extras.test.core" }`
- **DAP** — step-through debugger for Java: already wired in the java extra, just install `java-debug-adapter` via Mason
- **Update setup-dotfiles.sh** — add `link nvim "$HOME/.config/nvim"` to auto-link on next WSL rebuild

---

## Wiring into the WSL build (when ready to commit)

Add to `tools/wsl/images/markus-dev/scripts/setup-dotfiles.sh`:
```bash
link nvim "$HOME/.config/nvim"
```

And in the `Dockerfile` or `install-packages.sh` add:
```bash
# Neovim AppImage
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod +x nvim-linux-x86_64.appimage && mv nvim-linux-x86_64.appimage /usr/local/bin/nvim

# lazygit
LGVER=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name": "v\K[^"]+')
curl -Lo /tmp/lg.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LGVER}_Linux_x86_64.tar.gz"
tar xf /tmp/lg.tar.gz -C /usr/local/bin lazygit
```
