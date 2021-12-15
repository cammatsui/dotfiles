# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from typing import List  # noqa: F401

from libqtile import bar, layout, widget, hook, extension
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

from plasma import Plasma

import os
import subprocess

mod = "mod4"
terminal = "kitty"
browser = "firefox"

## STARTUP
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~')
    subprocess.Popen([home + '/.config/qtile/autostart.sh'])

## COLOR CONFIGURATION
colors = {
    'bg0': '#272822',
    'bg1': '#3e3d32',
    'fg0': '#f8f8f2',
    'fg1': '#cfcfc2',
    'yellow': '#e6db74',
    'orange': '#fd971f',
    'red': '#f92672',
    'magenta': '#fd5ff0',
    'violet': '#ae81ff',
    'blue': '#55d9ef',
    'cyan': '#a1efe4',
    'green': '#a6e22e'
}

## KEYBINDINGS
keys = [
    # Switch between windows
    Key([mod], "h", lazy.layout.left(),
        desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(),
        desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(),
        desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(),
        desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(),
        desc="Move window focus to other window"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(),
        desc="Move window up"),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(),
        desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(),
        desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(),
        desc="Reset all window sizes"),


    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "Return", lazy.spawn(terminal),
        desc="Launch terminal"),
    Key([mod], "b", lazy.spawn(browser),
        desc="Launch browser"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(),
        desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(),
        desc="Kill focused window"),

    Key([mod, "control"], "r", lazy.restart(),
        desc="Restart Qtile"),
    Key([mod, "control"], "q", lazy.shutdown(),
        desc="Shutdown Qtile"),
    Key([mod], "r", lazy.run_extension(extension.DmenuRun(
        dmenu_prompt=">"
    )))
]

keys += [
    # Plasma Keybindings

    # Grow a window.
    Key([mod, "control"], "h", lazy.layout.grow_width(30),
        desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_width(-30),
        desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_height(-30),
        desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_height(30),
        desc="Grow window up"),

    # Set split mode.
    Key([mod], "v", lazy.layout.mode_vertical_split(),
        desc="Vertical split mode"),
    Key([mod], "d", lazy.layout.mode_horizontal_split(),
        desc="Horizontal split mode"),

    # Shuffle windows.
    Key([mod, "shift"], "h", lazy.layout.move_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.move_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.move_down(),
        desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.move_up(),
        desc="Move window up"),

    # Reset window size.
    Key([mod], "n", lazy.layout.reset_size(),
        desc="Reset all window sizes"),

    Key([], "XF86AudioMute", lazy.spawn("amixer -q set Master toggle")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -c 0 sset Master 1- unmute")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -c 0 sset Master 1+ unmute"))
]

## WORKSPACES
groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name)),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
        #     desc="move focused window to group {}".format(i.name)),
    ])

## LAYOUTS
layouts = [
    Plasma(
        border_normal=colors['bg0'],
        border_focus=colors['yellow'],
        border_normal_fixed=colors['yellow'],
        border_focus_fixed=colors['yellow'],
        border_width=1,
        border_width_single=0,
        margin=8
    ),
    layout.Max()
]

## WIDGETS
widget_defaults = dict(
    font='sans',
    fontsize=12,
    padding=3,
    background=colors['bg0'],
    foreground=colors['fg0']
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    active=colors['fg0'],
                    this_current_screen_border=colors['blue'],
                    borderwidth=1,
                ),
                widget.Prompt(
                ),
                widget.WindowName(
                ),
                widget.Chord(
                    chords_colors={
                        'launch': ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.Volume(),
                widget.Systray(
                    background=colors['bg0']
                ),
                widget.Clock(
                    format=' | %I:%M %p   %m/%d',
                ),
                widget.Battery(
                    charge_char='+',
                    dischage_char='-',
                    empty_char='x',
                    format='| {char} {percent: 2.0%} {hour:d}:{min:02d} |'
                ),
                widget.QuickExit(
                    default_text='[ Log Out ]'
                ),
            ],
            24,
        ),
    ),
]

## MOUSE FOR FLOATING LAYOUTS
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
])
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True
# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
wmname = "LG3D"
