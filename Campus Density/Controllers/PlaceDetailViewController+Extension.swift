//
//  PlaceDetailViewController+Extension.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

extension PlaceDetailViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var description = "Closed"
        if !densityMap.isEmpty {
            description = "\(getHourLabel(selectedHour: selectedHour)) - \(getCurrentDensity(densityMap: densityMap, selectedHour: selectedHour))"
        }
        let weekday = getWeekday() == selectedWeekday ? "Today" : selectedWeekdayText()
        let date = selectedDateText()
        var hours = "No hours available"
        if let selectedWeekdayHours = place.hours[selectedWeekday] {
            hours = selectedWeekdayHours
        }
        return [
            SpaceModel(space: Constants.smallPadding),
            CurrentDensityModel(place: place),
            SpaceModel(space: linkTopOffset),
            FormLinkModel(feedbackForm: feedbackForm),
            SpaceModel(space: Constants.smallPadding),
            GraphHeaderModel(selectedWeekday: selectedWeekday, weekdays: weekdays),
            SpaceModel(space: Constants.largePadding),
            GraphModel(description: description, densityMap: densityMap, selectedHour: selectedHour),
            SpaceModel(space: Constants.largePadding),
            HoursHeaderModel(weekday: weekday, date: date),
            SpaceModel(space: Constants.mediumPadding),
            HoursModel(hours: hours),
            SpaceModel(space: Constants.largePadding - Constants.smallPadding)
        ]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is SpaceModel {
            let spaceModel = object as! SpaceModel
            return SpaceSectionController(spaceModel: spaceModel)
        } else if object is CurrentDensityModel {
            let currentDensityModel = object as! CurrentDensityModel
            return CurrentDensitySectionController(currentDensityModel: currentDensityModel)
        } else if object is FormLinkModel {
            let formLinkModel = object as! FormLinkModel
            return FormLinkSectionController(formLinkModel: formLinkModel, delegate: self)
        } else if object is GraphHeaderModel {
            let graphHeaderModel = object as! GraphHeaderModel
            return GraphHeaderSectionController(graphHeaderModel: graphHeaderModel, delegate: self)
        } else if object is GraphModel {
            let graphModel = object as! GraphModel
            return GraphSectionController(graphModel: graphModel, delegate: self)
        } else if object is HoursHeaderModel {
            let hoursHeaderModel = object as! HoursHeaderModel
            return HoursHeaderSectionController(hoursHeaderModel: hoursHeaderModel)
        } else {
            let hoursModel = object as! HoursModel
            return HoursSectionController(hoursModel: hoursModel)
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

extension PlaceDetailViewController: FormLinkSectionControllerDelegate {
    
    func formLinkSectionControllerDidPressLinkButton(link: String) {
        guard let url = URL(string: feedbackForm) else { return }
        UIApplication.shared.open(url)
    }
    
}

extension PlaceDetailViewController: GraphHeaderSectionControllerDelegate {
    
    func graphHeaderSectionControllerDidSelectWeekday(selectedWeekday: Int) {
        if selectedWeekday != self.selectedWeekday {
            self.selectedWeekday = selectedWeekday
            getDensityMap()
            adapter.performUpdates(animated: false, completion: nil)
        }
    }
    
}

extension PlaceDetailViewController: GraphSectionControllerDelegate {
    
    func graphSectionControllerDidSelectHour(selectedHour: Int) {
        if selectedHour != self.selectedHour {
            self.selectedHour = selectedHour
            adapter.performUpdates(animated: false, completion: nil)
        }
    }
    
}
