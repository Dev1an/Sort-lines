//
//  ViewController.swift
//  Sort Lines
//
//  Created by Damiaan on 01-11-16.
//  Copyright © 2016 Damiaan. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBAction func openPreferencePane(_ sender: Any) {
        NSWorkspace.shared().open(URL(fileURLWithPath: "/System/Library/PreferencePanes/Extensions.prefPane"))
    }

}

