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

# Emacs like online text editing
config.unbind('<Ctrl-e>', mode="insert")
config.bind('<Ctrl-e>', 'fake-key <Ctrl-Right>', mode="insert")
config.bind('<Ctrl-a>', 'fake-key <Ctrl-Left>', mode="insert")
config.bind('<Ctrl-u>', 'fake-key <Home><Shift-End><Delete>', mode="insert")
config.bind('<Ctrl-k>', 'fake-key <Shift-End><Delete>', mode="insert")
config.bind('<Ctrl-w>', 'fake-key <Alt-Backspace>', mode="insert")
config.bind('<Alt-f>', 'fake-key <Alt-Right>', mode="insert")
config.bind('<Alt-b>', 'fake-key <Alt-Left>', mode="insert")
config.bind('<Ctrl+j>', 'completion-item-focus next', mode="command")
config.bind('<Ctrl+k>', 'completion-item-focus prev', mode="command")
