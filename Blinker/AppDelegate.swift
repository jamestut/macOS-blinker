//
//  AppDelegate.swift
//  Blinker
//
//  Created by jamesn on 20/12/2022.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!
    
    private var color1: NSColor!
    private var color2: NSColor!
    private var activeImage: NSImage!
    private var inactiveImage: NSImage!
    
    private var timer: Timer!
    
    private var whichColor: Bool = false
    private var active: Bool = true
    
    private var statusItem: NSStatusItem!
    private var togglerMenu: NSMenuItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        color1 = NSColor(red: 1, green: 1, blue: 1, alpha: 1)
        color2 = NSColor(red: 0, green: 0, blue: 0, alpha: 1)
        activeImage = NSImage(systemSymbolName: "record.circle", accessibilityDescription: "Active")
        inactiveImage = NSImage(systemSymbolName: "circle", accessibilityDescription: "Inactive")
        
        createWindow()
        setupMenuBar()
        startTimer()
    }
    
    func createWindow() {
        window = NSWindow(contentRect: NSMakeRect(0, 0, 2, 2),
                          styleMask: [.borderless],
            backing: .buffered,
            defer: false)
        window?.title = "Coba App"
        window?.makeKeyAndOrderFront(nil)
        window?.isMovableByWindowBackground = false
        window?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.mainMenuWindow)))
        window?.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .ignoresCycle]
    }
    
    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = activeImage
        }
        
        let menu = NSMenu()

        togglerMenu = NSMenuItem(title: "Turn Off", action: #selector(toggle), keyEquivalent: "t")
        menu.addItem(togglerMenu)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        statusItem.menu = menu
    }
    
    @objc func toggle() {
        if active {
            // turn off
            togglerMenu.title = "Turn On"
            statusItem.button!.image = inactiveImage
            timer.invalidate()
            window.backgroundColor = color1
        } else {
            // turn on
            togglerMenu.title = "Turn Off"
            statusItem.button!.image = activeImage
            startTimer()
        }
        active = !active
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0/30.0,
                                     target: self,
                                     selector: #selector(onFire),
                                     userInfo: nil,
                                     repeats: true)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return false
    }
                                         
    @objc private func onFire() {
        window.backgroundColor = whichColor ? color1 : color2;
        whichColor = !whichColor;
    }
}
