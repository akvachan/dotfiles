# config.py for qutebrowser
config.load_autoconfig()

# Enable native macOS window decorations (title bar with traffic lights)
config.set("window.hide_decoration", False)

# Use Retina display scaling
config.set("qt.highdpi", True)

# Hide the status bar unless needed
config.set("statusbar.show", "in-mode")

# Hide the tab bar unless multiple tabs are open
config.set("tabs.show", "never")

# Set a default font for better Mac rendering
c.fonts.default_family = "SF Pro Text"

# Default font for qutebrowser UI
monospace: str = "20px 'SF Pro Text'"

# Font used in the completion categories.
c.fonts.completion.category = f"bold {monospace}"

# Font used in the completion widget.
c.fonts.completion.entry = monospace

# Font used for the debugging console.
c.fonts.debug_console = monospace

# Font used for the downloadbar.
c.fonts.downloads = monospace

# Font used in the keyhint widget.
c.fonts.keyhint = monospace

# Font used for error messages.
c.fonts.messages.error = monospace

# Font used for info messages.
c.fonts.messages.info = monospace

# Font used for warning messages.
c.fonts.messages.warning = monospace

# Font used for prompts.
c.fonts.prompts = monospace

# Font used in the statusbar.
c.fonts.statusbar = monospace

# Emacs-like keybindings 

# Jumpt to the end of the line
config.unbind('<Ctrl-e>', mode="insert")
config.bind('<Ctrl-e>', 'fake-key <Ctrl-Right>', mode="insert")

# Jump to the beginning of the line
config.bind('<Ctrl-a>', 'fake-key <Ctrl-Left>', mode="insert")

# Delete from the end until current cursor position
config.bind('<Ctrl-u>', 'fake-key <Home><Shift-End><Delete><Backspace>', mode="insert")

# Delete from the start until current cursor position
config.bind('<Ctrl-k>', 'fake-key <Shift-End><Delete>', mode="insert")

# Delete previous word
config.bind('<Ctrl-w>', 'fake-key <Alt-Backspace>', mode="insert")

# Jump to the next word
config.bind('<Alt-f>', 'fake-key <Alt-Right>', mode="insert")

# Jump to the previous word
config.bind('<Alt-b>', 'fake-key <Alt-Left>', mode="insert")

# Select next completion item in the command menu
config.bind('<Ctrl+j>', 'completion-item-focus next', mode="command")

# Select previous completion item in the command menu
config.bind('<Ctrl+k>', 'completion-item-focus prev', mode="command")

# Colorscheme

# GitHub Dark Dimmed color scheme for qutebrowser
# Based on GitHub's official color palette
# Add this to your config.py file

# Background color of the completion widget category headers
c.colors.completion.category.bg = '#1c2128'

# Bottom border color of the completion widget category headers
c.colors.completion.category.border.bottom = '#1c2128'

# Top border color of the completion widget category headers
c.colors.completion.category.border.top = '#1c2128'

# Foreground color of completion widget category headers
c.colors.completion.category.fg = '#adbac7'

# Background color of the completion widget for even rows
c.colors.completion.even.bg = '#22272e'

# Background color of the completion widget for odd rows
c.colors.completion.odd.bg = '#1c2128'

# Text color of the completion widget
c.colors.completion.fg = '#adbac7'

# Background color of the selected completion item
c.colors.completion.item.selected.bg = '#539bf5'

# Bottom border color of the selected completion item
c.colors.completion.item.selected.border.bottom = '#539bf5'

# Top border color of the selected completion item
c.colors.completion.item.selected.border.top = '#539bf5'

# Foreground color of the selected completion item
c.colors.completion.item.selected.fg = '#22272e'

# Foreground color of the matched text in the completion
c.colors.completion.item.selected.match.fg = '#daaa3f'

# Foreground color of the matched text in the completion widget
c.colors.completion.match.fg = '#6cb6ff'

# Color of the scrollbar in the completion view
c.colors.completion.scrollbar.bg = '#1c2128'

# Color of the scrollbar handle in the completion view
c.colors.completion.scrollbar.fg = '#539bf5'

# Background color for the download bar
c.colors.downloads.bar.bg = '#22272e'

# Background color for downloads with errors
c.colors.downloads.error.bg = '#f47067'

# Foreground color for downloads with errors
c.colors.downloads.error.fg = '#adbac7'

# Color gradient start for download backgrounds
c.colors.downloads.start.bg = '#539bf5'

# Color gradient start for download text
c.colors.downloads.start.fg = '#adbac7'

# Color gradient stop for download backgrounds
c.colors.downloads.stop.bg = '#57ab5a'

# Color gradient stop for download text
c.colors.downloads.stop.fg = '#adbac7'

# Background color for hints
c.colors.hints.bg = '#daaa3f'

# Font color for hints
c.colors.hints.fg = '#22272e'

# Font color for the matched part of hints
c.colors.hints.match.fg = '#539bf5'

# Background color of the keyhint widget
c.colors.keyhint.bg = '#22272e'

# Text color for the keyhint widget
c.colors.keyhint.fg = '#adbac7'

# Highlight color for keys to complete the current keychain
c.colors.keyhint.suffix.fg = '#6cb6ff'

# Background color of an error message
c.colors.messages.error.bg = '#f47067'

# Border color of an error message
c.colors.messages.error.border = '#f47067'

# Foreground color of an error message
c.colors.messages.error.fg = '#adbac7'

# Background color of an info message
c.colors.messages.info.bg = '#539bf5'

# Border color of an info message
c.colors.messages.info.border = '#539bf5'

# Foreground color an info message
c.colors.messages.info.fg = '#adbac7'

# Background color of a warning message
c.colors.messages.warning.bg = '#c69026'

# Border color of a warning message
c.colors.messages.warning.border = '#c69026'

# Foreground color a warning message
c.colors.messages.warning.fg = '#adbac7'

# Background color for prompts
c.colors.prompts.bg = '#22272e'

# Border used around UI elements in prompts
c.colors.prompts.border = '#539bf5'

# Foreground color for prompts
c.colors.prompts.fg = '#adbac7'

# Background color for the selected item in filename prompts
c.colors.prompts.selected.bg = '#539bf5'

# Foreground color for the selected item in filename prompts
c.colors.prompts.selected.fg = '#22272e'

# Background color of the statusbar in caret mode
c.colors.statusbar.caret.bg = '#b083f0'

# Foreground color of the statusbar in caret mode
c.colors.statusbar.caret.fg = '#adbac7'

# Background color of the statusbar in caret mode with a selection
c.colors.statusbar.caret.selection.bg = '#b083f0'

# Foreground color of the statusbar in caret mode with a selection
c.colors.statusbar.caret.selection.fg = '#adbac7'

# Background color of the statusbar in command mode
c.colors.statusbar.command.bg = '#22272e'

# Foreground color of the statusbar in command mode
c.colors.statusbar.command.fg = '#adbac7'

# Background color of the statusbar in private browsing + command mode
c.colors.statusbar.command.private.bg = '#22272e'

# Foreground color of the statusbar in private browsing + command mode
c.colors.statusbar.command.private.fg = '#adbac7'

# Background color of the statusbar in insert mode
c.colors.statusbar.insert.bg = '#57ab5a'

# Foreground color of the statusbar in insert mode
c.colors.statusbar.insert.fg = '#22272e'

# Background color of the statusbar
c.colors.statusbar.normal.bg = '#22272e'

# Foreground color of the statusbar
c.colors.statusbar.normal.fg = '#adbac7'

# Background color of the statusbar in passthrough mode
c.colors.statusbar.passthrough.bg = '#39c5cf'

# Foreground color of the statusbar in passthrough mode
c.colors.statusbar.passthrough.fg = '#22272e'

# Background color of the statusbar in private browsing mode
c.colors.statusbar.private.bg = '#1c2128'

# Foreground color of the statusbar in private browsing mode
c.colors.statusbar.private.fg = '#768390'

# Background color of the progress bar
c.colors.statusbar.progress.bg = '#539bf5'

# Foreground color of the URL in the statusbar on error
c.colors.statusbar.url.error.fg = '#f47067'

# Default foreground color of the URL in the statusbar
c.colors.statusbar.url.fg = '#adbac7'

# Foreground color of the URL in the statusbar for hovered links
c.colors.statusbar.url.hover.fg = '#6cb6ff'

# Foreground color of the URL in the statusbar on successful load
c.colors.statusbar.url.success.http.fg = '#57ab5a'

# Foreground color of the URL in the statusbar on successful load (HTTPS)
c.colors.statusbar.url.success.https.fg = '#57ab5a'

# Foreground color of the URL in the statusbar when there's a warning
c.colors.statusbar.url.warn.fg = '#daaa3f'

# Background color of the tab bar
c.colors.tabs.bar.bg = '#1c2128'

# Background color of unselected even tabs
c.colors.tabs.even.bg = '#1c2128'

# Foreground color of unselected even tabs
c.colors.tabs.even.fg = '#768390'

# Color for the tab indicator on errors
c.colors.tabs.indicator.error = '#f47067'

# Color gradient start for the tab indicator
c.colors.tabs.indicator.start = '#539bf5'

# Color gradient end for the tab indicator
c.colors.tabs.indicator.stop = '#57ab5a'

# Background color of unselected odd tabs
c.colors.tabs.odd.bg = '#1c2128'

# Foreground color of unselected odd tabs
c.colors.tabs.odd.fg = '#768390'

# Background color of pinned unselected even tabs
c.colors.tabs.pinned.even.bg = '#1c2128'

# Foreground color of pinned unselected even tabs
c.colors.tabs.pinned.even.fg = '#768390'

# Background color of pinned unselected odd tabs
c.colors.tabs.pinned.odd.bg = '#1c2128'

# Foreground color of pinned unselected odd tabs
c.colors.tabs.pinned.odd.fg = '#768390'

# Background color of pinned selected even tabs
c.colors.tabs.pinned.selected.even.bg = '#22272e'

# Foreground color of pinned selected even tabs
c.colors.tabs.pinned.selected.even.fg = '#adbac7'

# Background color of pinned selected odd tabs
c.colors.tabs.pinned.selected.odd.bg = '#22272e'

# Foreground color of pinned selected odd tabs
c.colors.tabs.pinned.selected.odd.fg = '#adbac7'

# Background color of selected even tabs
c.colors.tabs.selected.even.bg = '#22272e'

# Foreground color of selected even tabs
c.colors.tabs.selected.even.fg = '#adbac7'

# Background color of selected odd tabs
c.colors.tabs.selected.odd.bg = '#22272e'

# Foreground color of selected odd tabs
c.colors.tabs.selected.odd.fg = '#adbac7'

# Background color for webpages if unset (or empty to use the theme's color)
# c.colors.webpage.bg = '#22272e'

c.colors.webpage.darkmode.enabled = False
