gui = require 'nw.gui'
win = gui.Window.get()

menubar = new gui.Menu({ type: 'menubar' })
file = new gui.Menu()
help = new gui.Menu()
win.menu = menubar
win.menu.insert new gui.MenuItem( { label: 'File', submenu: file } ), 1
win.menu.append new gui.MenuItem( { label: 'Help', submenu: help } )
