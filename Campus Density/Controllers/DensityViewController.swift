//
//  DensityViewController.swift
//  Campus Density
//
//  Created by Matthew Coufal on 11/9/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit

class DensityViewController: UIViewController {

    // MARK: - Data vars
    var place: Place!
    var densityMap = [Int : Density]()
    var selectedHour: Int = 10
    
    // MARK: - View vars
    var axis: UIView!
    var currentLabel: UILabel!
    var hoursLabel: UILabel!
    var bars = [UIButton]()
    var densityDescriptionLabel: UILabel!
    
    // MARK: - Constants
    let axisHeight: CGFloat = 2
    let axisHorizontalPadding: CGFloat = 20
    let hoursVerticalPadding: CGFloat = 15
    let barVerticalPadding: CGFloat = 85
    let descriptionLabelHorizontalPadding: CGFloat = 15
    let descriptionLabelHeight: CGFloat = 40
    let descriptionLabelCornerRadius: CGFloat = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        densityMap = [
            10: .manySpots,
            11: .someSpots,
            12: .fewSpots,
            13: .noSpots,
            14: .someSpots,
            15: .fewSpots,
            16: .noSpots
        ]

        view.backgroundColor = .white
        title = place.displayName
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .warmGray
        
        setupViews()
        setupConstraints()
        
    }
    
    func setupViews() {
        axis = UIView()
        axis.backgroundColor = .whiteTwo
        axis.clipsToBounds = true
        axis.layer.cornerRadius = axisHeight / 2
        view.addSubview(axis)
        
        currentLabel = UILabel()
        currentLabel.textColor = .warmGray
//        currentLabel.textColor = isOpen() ? .lightTeal : .orangeyRed
        currentLabel.text = "Hours"
//        currentLabel.text = isOpen() ? "Open" : "Closed"
        currentLabel.textAlignment = .center
        currentLabel.font = .eighteenBold
        view.addSubview(currentLabel)
        
        hoursLabel = UILabel()
        hoursLabel.textColor = .grayishBrown
        hoursLabel.text = "7:00 AM - 10:00 AM\n5:00 PM - 8:00 PM"
        hoursLabel.textAlignment = .center
        hoursLabel.numberOfLines = 0
        hoursLabel.font = .eighteen
        view.addSubview(hoursLabel)
        
        densityDescriptionLabel = UILabel()
        densityDescriptionLabel.textColor = .grayishBrown
        densityDescriptionLabel.clipsToBounds = true
        densityDescriptionLabel.backgroundColor = .white
        densityDescriptionLabel.layer.borderColor = UIColor.warmGray.cgColor
        densityDescriptionLabel.layer.borderWidth = 1
        densityDescriptionLabel.font = .eighteen
        densityDescriptionLabel.numberOfLines = 0
        densityDescriptionLabel.textAlignment = .center
        densityDescriptionLabel.text = "7 AM - \(getCurrentDensity())"
        densityDescriptionLabel.layer.cornerRadius = descriptionLabelCornerRadius
        view.addSubview(densityDescriptionLabel)
    }
    
    func getCurrentDensity() -> String {
        switch densityMap[selectedHour]! {
        case .noSpots:
            return "No spots"
        case .fewSpots:
            return "Few spots"
        case .someSpots:
            return "Some spots"
        case .manySpots:
            return "Many spots"
        }
    }
    
    func isOpen() -> Bool {
        return true
    }
    
    func setupConstraints() {
        let navOffset: CGFloat = UIApplication.shared.statusBarFrame.height + navigationController!.navigationBar.frame.height
        let currentLabelBottomInset: CGFloat = (view.frame.height - (view.frame.height / 2)) / 2
        let maxBarHeight: CGFloat = view.frame.height / 2.0 - navOffset - barVerticalPadding
        let descriptionCenterY: CGFloat = navOffset + barVerticalPadding * 0.75
        
        axis.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(axisHorizontalPadding * 2)
            make.height.equalTo(axisHeight)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.centerY).offset(navOffset)
        }
        
        currentLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().inset(currentLabelBottomInset)
            make.centerX.equalToSuperview()
        }
        
        hoursLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(currentLabel.snp.bottom).offset(hoursVerticalPadding)
            make.centerX.equalToSuperview()
        }
        
        guard let description = densityDescriptionLabel.text else { return }
        let descriptionWidth = description.widthWithConstrainedHeight(descriptionLabelHeight, font: .eighteen)
        
        densityDescriptionLabel.snp.makeConstraints { make in
            make.width.equalTo(descriptionWidth + descriptionLabelHorizontalPadding * 2)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(descriptionCenterY)
        }
        
        layoutBars(maxBarHeight: maxBarHeight, startHour: 10, endHour: 16)
    }
    
    @objc func didTapBar(sender: UIButton) {
//        let hour = sender.tag
//
    }
    
    func layoutBars(maxBarHeight: CGFloat, startHour: Int, endHour: Int) {
        var hour: Int = startHour
        var barLeftOffset: CGFloat = 0
        let barWidth: CGFloat = (view.frame.width - axisHorizontalPadding * 4) / CGFloat(densityMap.keys.count)
        while hour <= endHour {
            if let density = densityMap[hour] {
                let bar = UIButton()
                bar.tag = hour
                bar.addTarget(self, action: #selector(didTapBar), for: .touchUpInside)
                var barHeight: CGFloat!
                switch density {
                case .noSpots:
                    bar.backgroundColor = .orangeyRed
                    barHeight = maxBarHeight
                    break
                case .fewSpots:
                    bar.backgroundColor = .peach
                    barHeight = maxBarHeight * 0.75
                    break
                case .someSpots:
                    bar.backgroundColor = .wheat
                    barHeight = maxBarHeight * 0.5
                    break
                case .manySpots:
                    bar.backgroundColor = .lightTeal
                    barHeight = maxBarHeight * 0.25
                }
                bar.clipsToBounds = true
                bar.layer.cornerRadius = 5
                bar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                self.view.addSubview(bar)
                
                bar.snp.makeConstraints({ make in
                    make.width.equalTo(barWidth)
                    make.height.equalTo(barHeight)
                    make.left.equalTo(axis).offset(barLeftOffset)
                    make.bottom.equalTo(self.axis.snp.top)
                })
                self.bars.append(bar)
            }
            barLeftOffset += barWidth
            hour += 1
        }
    }

}
