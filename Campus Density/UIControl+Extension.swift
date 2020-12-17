//
//  UIControl+Extension.swift
//  Campus Density
//
//  Created by Changyuan Lin on 12/5/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//
//  Adapted from https://stackoverflow.com/a/44917661
//

import UIKit

class ClosureSleeve {
    let closure: () -> Void

    init(attachTo: AnyObject, closure: @escaping () -> Void) {
        self.closure = closure
        objc_setAssociatedObject(attachTo, "[\(arc4random())]", self, .OBJC_ASSOCIATION_RETAIN)
    }

    @objc func invoke() {
        closure()
    }
}

extension UIControl {
    func addHandler(for controlEvents: UIControl.Event, action: @escaping () -> Void) {
        let sleeve = ClosureSleeve(attachTo: self, closure: action)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
    }
}
