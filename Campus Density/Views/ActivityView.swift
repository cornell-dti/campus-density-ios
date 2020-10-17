//
//  ActivityView.swift
//  Campus Density
//
//  Created by Mihikaa Goenka on 18/10/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

class ActivityView: UIView {

    let loadingCircle = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)

        /* create an activity indicator for when the menu data hasn't loaded */
        self.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        let outline = self.bounds
        let path = UIBezierPath(ovalIn: outline)
        loadingCircle.path = path.cgPath
        loadingCircle.lineWidth = 3
        loadingCircle.strokeEnd = 0.25
        loadingCircle.lineCap = .round

        loadingCircle.strokeColor = UIColor.black.cgColor
        loadingCircle.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(loadingCircle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /* animate the loading circle by calling this function*/
    func animate() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
            self.transform = CGAffineTransform(rotationAngle: .pi)
        }) { (_) in
            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {self.transform = CGAffineTransform(rotationAngle: 0)
            }) { (_) in
                self.animate()
            }
        }
    }
}
