//
//  LoadingBarsView.swift
//  Campus Density
//
//  Created by Matthew Coufal on 11/29/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit

class LoadingBarsView: UIView {
    
    // MARK: - Data vars
    var animating: Bool = false
    var shouldLayout = [false, false, false, false]
    
    // MARK: - View vars
    var barOne: UIView!
    var barTwo: UIView!
    var barThree: UIView!
    var barFour: UIView!
    
    // MARK: - Constants
    let barWidth: CGFloat = 15
    let maxBarHeight: CGFloat = 100
    let minBarHeight: CGFloat = 25
    let barCornerRadius: CGFloat = 5
    let padding: CGFloat = 1

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        barOne = UIView()
        barOne.clipsToBounds = true
        barOne.layer.cornerRadius = barCornerRadius
        barOne.backgroundColor = .lightTeal
        barOne.tag = 1
        addSubview(barOne)
        
        barTwo = UIView()
        barTwo.clipsToBounds = true
        barTwo.layer.cornerRadius = barCornerRadius
        barTwo.backgroundColor = .wheat
        barTwo.tag = 2
        addSubview(barTwo)
        
        barThree = UIView()
        barThree.clipsToBounds = true
        barThree.layer.cornerRadius = barCornerRadius
        barThree.backgroundColor = .peach
        barThree.tag = 3
        addSubview(barThree)
        
        barFour = UIView()
        barFour.clipsToBounds = true
        barFour.layer.cornerRadius = barCornerRadius
        barFour.backgroundColor = .orangeyRed
        barFour.tag = 4
        addSubview(barFour)
        
        barOne.snp.makeConstraints { make in
            make.width.equalTo(barWidth)
            make.height.equalTo(randomHeight())
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        barTwo.snp.makeConstraints { make in
            make.width.equalTo(barWidth)
            make.height.equalTo(randomHeight())
            make.bottom.equalTo(barOne)
            make.left.equalTo(barOne.snp.right).offset(padding)
        }
        
        barThree.snp.makeConstraints { make in
            make.width.equalTo(barWidth)
            make.height.equalTo(randomHeight())
            make.bottom.equalTo(barOne)
            make.left.equalTo(barTwo.snp.right).offset(padding)
        }
        
        barFour.snp.makeConstraints { make in
            make.width.equalTo(barWidth)
            make.height.equalTo(randomHeight())
            make.bottom.equalTo(barOne)
            make.left.equalTo(barThree.snp.right).offset(padding)
        }
        
    }
    
    func startAnimating() {
        animating = true
        self.isHidden = false
        rise(bar: barOne)
        rise(bar: barTwo)
        rise(bar: barThree)
        rise(bar: barFour)
    }
    
    func stopAnimating() {
        animating = false
        shouldLayout = [false, false, false, false]
        self.isHidden = true
    }
    
    func rise(bar: UIView) {
        if animating {
            UIView.animate(withDuration: 0.3 + drand48(), animations: {
                bar.snp.updateConstraints({ update in
                    update.height.equalTo(self.maxBarHeight)
                })
                if self.shouldLayout[bar.tag - 1] {
                    self.layoutIfNeeded()
                }
                if !self.shouldLayout[bar.tag - 1] {
                    self.shouldLayout[bar.tag - 1].toggle()
                }
            }) { completed in
                if completed {
                    self.fall(bar: bar)
                }
            }
        }
    }
    
    func fall(bar: UIView) {
        if animating {
            UIView.animate(withDuration: 0.3 + drand48(), animations: {
                bar.snp.updateConstraints({ update in
                    update.height.equalTo(self.minBarHeight)
                })
                if self.shouldLayout[bar.tag - 1] {
                    self.layoutIfNeeded()
                }
                if !self.shouldLayout[bar.tag - 1] {
                    self.shouldLayout[bar.tag - 1].toggle()
                }
            }) { completed in
                if completed {
                    self.rise(bar: bar)
                }
            }
        }
    }
    
    func randomHeight() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * maxBarHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
