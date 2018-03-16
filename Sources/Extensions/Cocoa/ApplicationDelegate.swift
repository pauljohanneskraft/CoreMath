//
//  ApplicationDelegate.swift
//  Math
//
//  Created by Paul Kraft on 09.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Cocoa

public protocol ApplicationDelegate: NSApplicationDelegate {
    static var shared: Self? { get set }
    
    init()
    
    var windows: [NSWindow] { get set }
    
    func open(window: NSWindow)
    func start(name: String)
    static func start(name: String) -> Self
}

extension ApplicationDelegate {
    public func open(window: NSWindow) {
        windows.append(window)
        // print("opening window", window)
        window.makeKeyAndOrderFront(self)
    }
    
    public func start(name: String) {
        let app = NSApplication.shared
        app.setActivationPolicy(.regular)
        let mainMenu = NSMenu()
        mainMenu.addItem(NSMenu.makeAppMenuItem(for: app, name: name))
        app.mainMenu = mainMenu
        app.delegate = self
    }
    
    @discardableResult
    public static func start(name: String) -> Self {
        let this = Self()
        shared = this
        this.start(name: name)
        return this
    }
}
