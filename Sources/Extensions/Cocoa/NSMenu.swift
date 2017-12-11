//
//  NSMenu.swift
//  Math
//
//  Created by Paul Kraft on 09.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Cocoa

extension NSMenu {
    static func makeAppMenuItem(for app: NSApplication, name: String) -> NSMenuItem {
        let hideOthers = NSMenuItem(title: "Hide Others",
                                    action: #selector(app.hideOtherApplications(_:)), keyEquivalent: "h")
        hideOthers.keyEquivalentModifierMask = [.command, .option]
        
        let appMenu = NSMenu(with: [
                .new(title: "About \(name)", action: nil, keyEquivalent: ""),
                .separator,
                .new(title: "Preferences...", action: nil, keyEquivalent: ","),
                .separator,
                .new(title: "Hide \(name)", action: #selector(app.hide(_:)), keyEquivalent: "h"),
                .item(hideOthers),
                .new(title: "Show All", action: #selector(app.unhideAllApplications(_:)), keyEquivalent: ""),
                .separator,
                .new(title: "Quit \(name)", action: #selector(app.terminate(_:)), keyEquivalent: "q")
            ]
        )
        
        let mainAppMenuItem = NSMenuItem(title: "Application", action: nil, keyEquivalent: "")
        mainAppMenuItem.submenu = appMenu
        return mainAppMenuItem
    }
}

extension NSMenu {
    convenience init(title: String = "", with items: [NSMenu.Item]) {
        self.init(title: title)
        addItems(items)
    }
    
    func addItems(_ items: [NSMenu.Item]) {
        items.forEach { self.addItem($0.menuItem) }
    }
}

extension NSMenu {
    enum Item {
        case separator
        case new(title: String, action: Selector?, keyEquivalent: String)
        case item(NSMenuItem)
        
        var menuItem: NSMenuItem {
            switch self {
            case .separator:
                return NSMenuItem.separator()
            case let .new(title, action, keyEquivalent):
                return NSMenuItem(title: title, action: action, keyEquivalent: keyEquivalent)
            case let .item(item):
                return item
            }
        }
    }
}
