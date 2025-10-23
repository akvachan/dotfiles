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

c.editor.command = ["kitty", "--single-instance", "-T", "auxiliary text edit", "nvim", "{file}", "+startinsert", "+call cursor({line}, {column})"]
