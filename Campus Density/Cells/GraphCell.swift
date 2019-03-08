//
//  GraphCell.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import UIKit

protocol GraphCellDelegate: class {
    
    func graphCellDidSelectHour(selectedHour: Int)
    
}

class GraphCell: UICollectionViewCell {
    
    // MARK: - Data vars
    var descriptionLabelText: String!
    var densityMap: [Int: Double]!
    var selectedHour: Int!
    weak var delegate: GraphCellDelegate?
    
    // MARK: - View vars
    var descriptionLabel: UILabel!
    var selectedView: UIView!
    var axis: UIView!
    var bars = [UIView]()
    
    // MARK: - Constants
    let descriptionLabelHeight: CGFloat = 40
    let descriptionLabelVerticalPadding: CGFloat = 50
    let descriptionLabelHorizontalPadding: CGFloat = 15
    let maxBarHeight: CGFloat = 150
    let axisLabelVerticalPadding: CGFloat = 10
    let axisLabelHeight: CGFloat = 15
    let axisHeight: CGFloat = 2
    let start: Int = 7
    let end: Int = 23
    let horizontalPadding: CGFloat = 15
    let selectedViewWidth: CGFloat = 1.5
    let descriptionLabelCornerRadius: CGFloat = 6
    let numTicks: Int = 3
    let smallTickHeight: CGFloat = 5
    let largeTickHeight: CGFloat = 10
    let barGraphViewVerticalPadding: CGFloat = 50
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupViews()
        let numBars = CGFloat(end - start + 3)
        let barWidth: CGFloat = (frame.width - horizontalPadding * 2) / numBars
        layoutAxis(barWidth: barWidth)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapBar(bar: UIView) {
        delegate?.graphCellDidSelectHour(selectedHour: bar.tag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            respondToTouch(location: location)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            let index = bars.firstIndex { bar -> Bool in
                return bar.frame.contains(location)
            }
            guard let barIndex = index else { return }
            if !bars[barIndex].isHidden {
                didTapBar(bar: bars[barIndex])
            }
        }
    }
    
    func respondToTouch(location: CGPoint) {
        let index = bars.firstIndex { bar -> Bool in
            return bar.frame.contains(location)
        }
        guard let barIndex = index else { return }
        
        if !bars[barIndex].isHidden {
            
            selectedHour = bars[barIndex].tag
            
            descriptionLabelText = "\(getHourLabel(selectedHour: selectedHour)) - \(getCurrentDensity(densityMap: densityMap, selectedHour: selectedHour))"
            descriptionLabel.text = descriptionLabelText
            let descriptionWidth = descriptionLabelText.widthWithConstrainedHeight(descriptionLabelHeight, font: descriptionLabel.font)
            
            descriptionLabel.snp.remakeConstraints { update in
                update.top.equalToSuperview()
                update.width.equalTo(descriptionWidth + Constants.smallPadding * 2)
                update.height.equalTo(descriptionLabelHeight)
                update.centerX.equalTo(bars[barIndex]).priority(.high)
                update.right.lessThanOrEqualToSuperview().offset(-Constants.smallPadding).priority(.required)
                update.left.greaterThanOrEqualToSuperview().offset(Constants.smallPadding).priority(.required)
            }
            
            selectedView.snp.remakeConstraints { update in
                update.width.equalTo(selectedViewWidth)
                update.top.equalTo(descriptionLabel.snp.bottom)
                update.bottom.equalTo(bars[barIndex].snp.top)
                update.centerX.equalTo(bars[barIndex])
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            respondToTouch(location: location)
        }
    }
    
    func setupViews() {
        descriptionLabel = UILabel()
        descriptionLabel.textColor = .grayishBrown
        descriptionLabel.clipsToBounds = true
        descriptionLabel.backgroundColor = .white
        descriptionLabel.layer.borderColor = UIColor.warmGray.cgColor
        descriptionLabel.layer.borderWidth = 1
        descriptionLabel.font = .eighteen
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.layer.cornerRadius = descriptionLabelCornerRadius
        addSubview(descriptionLabel)
        
        axis = UIView()
        axis.backgroundColor = .whiteTwo
        axis.clipsToBounds = true
        axis.layer.cornerRadius = axisHeight / 2
        addSubview(axis)
        
        selectedView = UIView()
        selectedView.backgroundColor = .warmGray
        addSubview(selectedView)
    }
    
    func layoutAxis(barWidth: CGFloat) {
        
        axis.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(Constants.smallPadding)
            make.height.equalTo(axisHeight)
            make.top.equalTo(descriptionLabelHeight + Constants.largePadding + maxBarHeight)
            make.centerX.equalToSuperview()
        }
        
        var startHour: Int = start
        let endHour: Int = end
        var tickLeftOffset: CGFloat = barWidth
        while startHour <= endHour {
            let tick = UIView()
            tick.clipsToBounds = true
            tick.layer.cornerRadius = axisHeight / 2
            tick.backgroundColor = .whiteTwo
            addSubview(tick)
            
            let shouldLabel = (endHour - startHour) % numTicks == 0
            
            tick.snp.makeConstraints { make in
                make.width.equalTo(axisHeight)
                make.height.equalTo(shouldLabel ? largeTickHeight : smallTickHeight)
                make.top.equalTo(axis.snp.bottom)
                make.centerX.equalTo(axis.snp.left).offset(tickLeftOffset)
            }
            
            if shouldLabel {
                let axisLabel = UILabel()
                let hour = startHour < 12 ? startHour : startHour - 12
                let descriptor = startHour < 12 ? "a" : "p"
                axisLabel.text = "\(hour)\(descriptor)"
                axisLabel.textAlignment = .center
                axisLabel.textColor = .grayishBrown
                axisLabel.font = .twelve
                addSubview(axisLabel)
                
                axisLabel.snp.makeConstraints { make in
                    make.height.equalTo(axisLabelHeight)
                    make.top.equalTo(tick.snp.bottom).offset(axisLabelVerticalPadding)
                    make.centerX.equalTo(tick)
                }
            }
            
            tickLeftOffset += barWidth
            startHour += 1
        }
        
        let lastTick = UIView()
        lastTick.clipsToBounds = true
        lastTick.layer.cornerRadius = axisHeight / 2
        lastTick.backgroundColor = .whiteTwo
        addSubview(lastTick)
        
        lastTick.snp.makeConstraints { make in
            make.width.equalTo(axisHeight)
            make.height.equalTo(smallTickHeight)
            make.top.equalTo(axis.snp.bottom)
            make.centerX.equalTo(axis.snp.left).offset(tickLeftOffset)
        }
    }
    
    func layoutBars(barWidth: CGFloat) {
        var startHour: Int = start
        let endHour: Int = end
        var barLeftOffset: CGFloat = barWidth
        while startHour <= endHour {
            let bar = UIView()
            bar.tag = startHour
            var barHeight: CGFloat = 1
            if let historicalAverage = densityMap[startHour] {
                if historicalAverage < 0.25 {
                    bar.backgroundColor = .lightTeal
                } else if historicalAverage < 0.5 {
                    bar.backgroundColor = .wheat
                } else if historicalAverage < 0.75 {
                    bar.backgroundColor = .peach
                } else {
                    bar.backgroundColor = .orangeyRed
                }
                barHeight = maxBarHeight * CGFloat(historicalAverage < 0.075 ? 0.075 : historicalAverage)
            } else {
                bar.isHidden = true
            }
            bar.clipsToBounds = true
            bar.layer.cornerRadius = 5
            bar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            bar.layer.borderColor = UIColor.white.cgColor
            bar.layer.borderWidth = 0.5
            addSubview(bar)
            
            bar.snp.makeConstraints { make in
                make.width.equalTo(barWidth)
                make.height.equalTo(barHeight)
                make.left.equalTo(axis).offset(barLeftOffset)
                make.bottom.equalTo(axis.snp.top)
            }
            bars.append(bar)
            
            barLeftOffset += barWidth
            startHour += 1
        }
        
    }
    
    func setupConstraints() {
        
        if densityMap.isEmpty {
            let descriptionWidth = descriptionLabelText.widthWithConstrainedHeight(descriptionLabelHeight, font: descriptionLabel.font)
            let descriptionTopOffset = maxBarHeight / 2
            
            descriptionLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(descriptionTopOffset)
                make.width.equalTo(descriptionWidth + Constants.smallPadding * 2)
                make.height.equalTo(descriptionLabelHeight)
                make.centerX.equalToSuperview()
            }
        } else {
            let numBars = CGFloat(end - start + 3)
            let barWidth: CGFloat = (frame.width - Constants.smallPadding * 2) / numBars
            layoutBars(barWidth: barWidth)
            
            let descriptionWidth = descriptionLabelText.widthWithConstrainedHeight(descriptionLabelHeight, font: descriptionLabel.font)
            
            let index = bars.firstIndex(where: { bar -> Bool in
                return bar.tag == selectedHour
            })
            
            if let barIndex = index, let _ = densityMap[selectedHour] {
                descriptionLabel.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.width.equalTo(descriptionWidth + Constants.smallPadding * 2)
                    make.height.equalTo(descriptionLabelHeight)
                    make.centerX.equalTo(bars[barIndex]).priority(.high)
                    make.right.lessThanOrEqualToSuperview().offset(-Constants.smallPadding).priority(.required)
                    make.left.greaterThanOrEqualToSuperview().offset(Constants.smallPadding).priority(.required)
                }
                
                selectedView.snp.makeConstraints { make in
                    make.width.equalTo(selectedViewWidth)
                    make.top.equalTo(descriptionLabel.snp.bottom)
                    make.bottom.equalTo(bars[barIndex].snp.top)
                    make.centerX.equalTo(bars[barIndex])
                }
            } else {
                descriptionLabel.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.width.equalTo(descriptionWidth + Constants.smallPadding * 2)
                    make.height.equalTo(descriptionLabelHeight)
                    make.centerX.equalToSuperview()
                }
            }
        }
        
    }
    
    override func prepareForReuse() {
        for bar in bars {
            bar.removeFromSuperview()
        }
        bars = []
        descriptionLabel.snp.removeConstraints()
        selectedView.snp.removeConstraints()
    }
    
    func configure(description: String, densityMap: [Int: Double], selectedHour: Int, delegate: GraphCellDelegate) {
        self.descriptionLabelText = description
        descriptionLabel.text = description
        self.selectedHour = selectedHour
        self.delegate = delegate
        self.densityMap = densityMap
        setupConstraints()
    }
    
}
