# config.py for qutebrowser
config.load_autoconfig()

# ============================================================================
# Window and Display Settings
# ============================================================================

# Enable native macOS window decorations (title bar with traffic lights)
config.set("window.hide_decoration", False)

# Use Retina display scaling
config.set("qt.highdpi", True)

# Hide the status bar unless needed
config.set("statusbar.show", "in-mode")

# Hide the tab bar unless multiple tabs are open
config.set("tabs.show", "never")

# ============================================================================
# Font Configuration
# ============================================================================

# Set a default font for better Mac rendering
c.fonts.default_family = "SF Pro Text"

# Default font for qutebrowser UI
monospace: str = "20px 'SF Pro Text'"

# Font used in the completion categories
c.fonts.completion.category = f"bold {monospace}"

# Font used in the completion widget
c.fonts.completion.entry = monospace

# Font used for the debugging console
c.fonts.debug_console = monospace

# Font used for the downloadbar
c.fonts.downloads = monospace

# Font used in the keyhint widget
c.fonts.keyhint = monospace

# Font used for error messages
c.fonts.messages.error = monospace

# Font used for info messages
c.fonts.messages.info = monospace

# Font used for warning messages
c.fonts.messages.warning = monospace

# Font used for prompts
c.fonts.prompts = monospace

# Font used in the statusbar
c.fonts.statusbar = monospace

# ============================================================================
# Keybindings
# ============================================================================

# General keybindings
# Toggle dark mode
config.bind(
    "<Space>td",
    "config-cycle -u *://{url:host}/* colors.webpage.darkmode.enabled ;; reload",
)

# Open downloads
config.bind("<Space>do", "download-open")

# Open n-th download
config.bind("<Space>dn", "download-open --number")

# Insert mode keybindings
# Jump to the end of the line
config.unbind("<Ctrl-e>", mode="insert")
config.bind("<Ctrl-e>", "fake-key <Ctrl-Right>", mode="insert")

# Jump to the beginning of the line
config.bind("<Ctrl-a>", "fake-key <Ctrl-Left>", mode="insert")

# Delete from the end until current cursor position
config.bind("<Ctrl-u>", "fake-key <Home><Shift-End><Delete>", mode="insert")

# Delete from the start until current cursor position
config.bind("<Ctrl-k>", "fake-key <Shift-End><Delete>", mode="insert")

# Delete previous word
config.bind("<Ctrl-w>", "fake-key <Alt-Backspace>", mode="insert")

# Jump to the next word
config.bind("<Alt-f>", "fake-key <Alt-Right>", mode="insert")

# Jump to the previous word
config.bind("<Alt-b>", "fake-key <Alt-Left>", mode="insert")

# Command mode keybindings
# Select next completion item in the command menu
config.bind("<Ctrl+j>", "completion-item-focus next", mode="command")

# Select previous completion item in the command menu
config.bind("<Ctrl+k>", "completion-item-focus prev", mode="command")

# ============================================================================
# GitHub Theme for Qutebrowser
# ============================================================================

# Base colors
bg = "#22272e"
fg = "#adbac7"
selection_bg = "#539bf5"
selection_fg = "#22272e"

# Accent colors (derived from GitHub's palette)
blue = "#539bf5"
green = "#57ab5a"
yellow = "#c69026"
red = "#e5534b"
purple = "#b083f0"
gray = "#636e7b"
dark_bg = "#1c2128"
lighter_bg = "#2d333b"

# Completion widget
c.colors.completion.fg = fg
c.colors.completion.odd.bg = bg
c.colors.completion.even.bg = bg
c.colors.completion.category.fg = blue
c.colors.completion.category.bg = dark_bg
c.colors.completion.category.border.top = dark_bg
c.colors.completion.category.border.bottom = dark_bg
c.colors.completion.item.selected.fg = selection_fg
c.colors.completion.item.selected.bg = selection_bg
c.colors.completion.item.selected.border.top = selection_bg
c.colors.completion.item.selected.border.bottom = selection_bg
c.colors.completion.item.selected.match.fg = selection_fg
c.colors.completion.match.fg = blue
c.colors.completion.scrollbar.fg = gray
c.colors.completion.scrollbar.bg = bg

# Context menu
c.colors.contextmenu.disabled.bg = bg
c.colors.contextmenu.disabled.fg = gray
c.colors.contextmenu.menu.bg = bg
c.colors.contextmenu.menu.fg = fg
c.colors.contextmenu.selected.bg = selection_bg
c.colors.contextmenu.selected.fg = selection_fg

# Downloads
c.colors.downloads.bar.bg = bg
c.colors.downloads.start.fg = dark_bg
c.colors.downloads.start.bg = blue
c.colors.downloads.stop.fg = dark_bg
c.colors.downloads.stop.bg = green
c.colors.downloads.error.fg = red

# Hints
c.colors.hints.fg = selection_fg
c.colors.hints.bg = yellow
c.colors.hints.match.fg = blue

# Keyhint widget
c.colors.keyhint.fg = fg
c.colors.keyhint.suffix.fg = blue
c.colors.keyhint.bg = bg

# Messages
c.colors.messages.error.fg = red
c.colors.messages.error.bg = bg
c.colors.messages.error.border = red
c.colors.messages.warning.fg = yellow
c.colors.messages.warning.bg = bg
c.colors.messages.warning.border = yellow
c.colors.messages.info.fg = blue
c.colors.messages.info.bg = bg
c.colors.messages.info.border = blue

# Prompts
c.colors.prompts.fg = fg
c.colors.prompts.bg = bg
c.colors.prompts.border = blue
c.colors.prompts.selected.bg = selection_bg
c.colors.prompts.selected.fg = selection_fg

# Statusbar
c.colors.statusbar.normal.fg = fg
c.colors.statusbar.normal.bg = bg
c.colors.statusbar.insert.fg = dark_bg
c.colors.statusbar.insert.bg = blue
c.colors.statusbar.passthrough.fg = dark_bg
c.colors.statusbar.passthrough.bg = purple
c.colors.statusbar.private.fg = dark_bg
c.colors.statusbar.private.bg = lighter_bg
c.colors.statusbar.command.fg = fg
c.colors.statusbar.command.bg = bg
c.colors.statusbar.command.private.fg = fg
c.colors.statusbar.command.private.bg = bg
c.colors.statusbar.caret.fg = dark_bg
c.colors.statusbar.caret.bg = purple
c.colors.statusbar.caret.selection.fg = dark_bg
c.colors.statusbar.caret.selection.bg = blue
c.colors.statusbar.progress.bg = blue
c.colors.statusbar.url.fg = fg
c.colors.statusbar.url.error.fg = red
c.colors.statusbar.url.hover.fg = blue
c.colors.statusbar.url.success.http.fg = green
c.colors.statusbar.url.success.https.fg = green
c.colors.statusbar.url.warn.fg = yellow

# Tabs
c.colors.tabs.bar.bg = dark_bg
c.colors.tabs.indicator.start = blue
c.colors.tabs.indicator.stop = green
c.colors.tabs.indicator.error = red
c.colors.tabs.odd.fg = fg
c.colors.tabs.odd.bg = bg
c.colors.tabs.even.fg = fg
c.colors.tabs.even.bg = bg
c.colors.tabs.pinned.even.bg = lighter_bg
c.colors.tabs.pinned.even.fg = fg
c.colors.tabs.pinned.odd.bg = lighter_bg
c.colors.tabs.pinned.odd.fg = fg
c.colors.tabs.pinned.selected.even.fg = selection_fg
c.colors.tabs.pinned.selected.even.bg = selection_bg
c.colors.tabs.pinned.selected.odd.fg = selection_fg
c.colors.tabs.pinned.selected.odd.bg = selection_bg
c.colors.tabs.selected.odd.fg = selection_fg
c.colors.tabs.selected.odd.bg = selection_bg
c.colors.tabs.selected.even.fg = selection_fg
c.colors.tabs.selected.even.bg = selection_bg

# ============================================================================
# Webpage Colors (Commented)
# ============================================================================

c.colors.webpage.bg = bg
c.colors.webpage.preferred_color_scheme = 'dark'
# c.content.user_stylesheets = ['~/.qutebrowser/custom.css']
# c.colors.webpage.darkmode.enabled = True
