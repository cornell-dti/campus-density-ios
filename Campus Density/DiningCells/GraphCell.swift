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

class GraphCell: UICollectionViewCell, UIGestureRecognizerDelegate {

    // MARK: - Data vars
    var descriptionLabelText: String!
    var densityMap: [Int: Double]!
    var selectedHour: Int!
    weak var delegate: GraphCellDelegate?

    // MARK: - View vars
    var descriptionLabel: UILabel!
    var selectedView: UIView!
    var axis: UIView!
    var bars = [BarView]()
    var feedbackGenerator = UISelectionFeedbackGenerator()

    // MARK: - Constants
    let descriptionLabelHeight: CGFloat = 40
    let maxBarHeight: CGFloat = 150
    let axisLabelVerticalPadding: CGFloat = 10
    let axisLabelHeight: CGFloat = 15
    let axisHeight: CGFloat = 1
    let start: Int = 7
    let end: Int = 23
    let horizontalPadding: CGFloat = 15
    let selectedViewWidth: CGFloat = 1.5
    let descriptionLabelCornerRadius: CGFloat = 6
    let numTicks: Int = 3
    let smallTickHeight: CGFloat = 5
    let largeTickHeight: CGFloat = 10
    let barToLabelGap: CGFloat = Constants.largePadding
    let greyBarExtraHeight: CGFloat = Constants.largePadding / 2

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        setupViews()
        let numBars = CGFloat(end - start + 3)
        let barWidth: CGFloat = (frame.width - horizontalPadding * 2) / numBars
        layoutAxis(barWidth: barWidth)
        setupGestureRecognizers()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Returns the text description of density at a certain hour
    func descriptionLabelText(selectedHour: Int, densityMap: [Int: Double]) -> String {
        return "\(getHourLabel(selectedHour: selectedHour)) - \(getCurrentDensity(densityMap: densityMap, selectedHour: selectedHour))"
    }

    func setupGestureRecognizers() {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureChange(_:)))
        panRecognizer.delegate = self
        addGestureRecognizer(panRecognizer)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureChange(_:)))
        tapRecognizer.delegate = self
        addGestureRecognizer(tapRecognizer)
    }

    @objc func panGestureChange(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            respondToTouch(location: sender.location(in: self))
        case .ended, .failed, .cancelled, .possible:
            break
        }
    }

    @objc func tapGestureChange(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            respondToTouch(location: sender.location(in: self))
        }
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }

        // Sometimes want to scroll up/down
        let v = panRecognizer.velocity(in: self)
        return abs(v.x) > abs(v.y)
    }

    func didSelectHour(selectedHour: Int) {
        delegate?.graphCellDidSelectHour(selectedHour: selectedHour)
    }

    func respondToTouch(location: CGPoint) {
        let index = bars.firstIndex { bar -> Bool in
            return location.x < bar.frame.maxX && location.x > bar.frame.minX
        }
        guard let barIndex = index else { return }

        if selectedHour != bars[barIndex].tag {

            selectedHour = bars[barIndex].tag

            feedbackGenerator.selectionChanged()
            feedbackGenerator.prepare()

            descriptionLabelText = descriptionLabelText(selectedHour: selectedHour, densityMap: densityMap)
            descriptionLabel.text = descriptionLabelText

            setupConstraints()

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
        axis.backgroundColor = .warmGray
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
            make.top.equalTo(maxBarHeight + barToLabelGap + descriptionLabelHeight)
            make.centerX.equalToSuperview()
        }

        var startHour: Int = start
        let endHour: Int = end
        var tickLeftOffset: CGFloat = barWidth
        while startHour <= endHour {
            let tick = UIView()
            tick.clipsToBounds = true
            tick.layer.cornerRadius = axisHeight / 2
            tick.backgroundColor = .warmGray
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
        lastTick.backgroundColor = .warmGray
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
            let bar = BarView()
            bar.tag = startHour
            var barHeight: CGFloat = 1
            if let historicalAverage = densityMap[startHour] {
                bar.configureOpen(historicalAverage: historicalAverage)
                barHeight = maxBarHeight * CGFloat(historicalAverage < 0.075 ? 0.075 : historicalAverage) // Minimum bar height of 0.075
            } else {
                bar.configureClosed()
                barHeight = maxBarHeight + greyBarExtraHeight
            }
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
        let descriptionWidth = descriptionLabelText.widthWithConstrainedHeight(descriptionLabelHeight, font: descriptionLabel.font)

        let index = bars.firstIndex(where: { bar -> Bool in
            return bar.tag == selectedHour
        })

        if let barIndex = index {
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
                if bars[barIndex].isClosedTime {
                    selectedView.superview?.bringSubviewToFront(selectedView)
                    update.bottom.equalTo(bars[barIndex].snp.bottom)
                } else {
                    update.bottom.equalTo(bars[barIndex].snp.top)
                }
                update.centerX.equalTo(bars[barIndex])
            }
        }
    }

    override func prepareForReuse() {
        didSelectHour(selectedHour: selectedHour)
        for bar in bars {
            bar.removeFromSuperview()
        }
        bars = []
        descriptionLabel.snp.removeConstraints()
        selectedView.snp.removeConstraints()
    }

    func configure(densityMap: [Int: Double], selectedHour: Int, delegate: GraphCellDelegate) {
        self.selectedHour = selectedHour
        self.delegate = delegate
        self.densityMap = densityMap
        descriptionLabelText = descriptionLabelText(selectedHour: selectedHour, densityMap: densityMap)
        descriptionLabel.text = descriptionLabelText
        let numBars = CGFloat(end - start + 3)
        let barWidth: CGFloat = (frame.width - Constants.smallPadding * 2) / numBars
        layoutBars(barWidth: barWidth)
        setupConstraints()
    }

}

class BarView: UIView {

    var isClosedTime: Bool = false

    func configureOpen(historicalAverage: Double) {
        if historicalAverage < 0.25 {
            backgroundColor = .lightTeal
        } else if historicalAverage < 0.5 {
            backgroundColor = .wheat
        } else if historicalAverage < 0.85 {
            backgroundColor = .peach
        } else {
            backgroundColor = .orangeyRed
        }
        clipsToBounds = true
        layer.cornerRadius = 5
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 0.5
    }

    func configureClosed() {
        isClosedTime = true
        backgroundColor = .whiteTwo
    }

}
