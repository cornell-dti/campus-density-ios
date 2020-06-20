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
        let weekday = getCurrentWeekday() == selectedWeekday ? "Today" : selectedWeekdayText()
        let date = selectedDateText()
        var hours = "No hours available"
        var menus = DayMenus(menus: [], date: "help")
        if let selectedWeekdayHours = place.hours[selectedWeekday] {
            hours = selectedWeekdayHours
        }
        var menuDay = selectedWeekday + 1 - getCurrentWeekday()
        if (menuDay <= 0) {
            menuDay = 7 + menuDay
        }
        if place.menus.weeksMenus.count != 0 {
            menus = place.menus.weeksMenus[menuDay]
        }
        var meals = [Meal]()
        var endTimes = [Int]()
        if (menus.menus.count != 0) {
            for meal in menus.menus {
                if (meal.menu.count != 0) {
                    meals.append(Meal(rawValue: meal.description)!)
                    endTimes.append(meal.endTime)
                }
            }

            self.mealList = meals

            if !meals.contains(selectedMeal) && meals.count > 0 {
                let currentTime = Int(Date().timeIntervalSince1970)
                print("Current Time: \(currentTime)")
                selectedMeal = meals[0]
                for (index, endTime) in endTimes.enumerated() {
                    if currentTime < endTime {
                        print("\(currentTime) < \(endTime) at index \(index), which is \(meals[index]), choosing this")
                        selectedMeal = meals[index]
                        break
                    } else {
                        print("\(currentTime) > \(endTime) at index \(index), which is \(meals[index])")
                    }
                }
            }
        }
        return [
            SpaceModel(space: Constants.smallPadding),
            AvailabilityHeaderModel(),
            SpaceModel(space: Constants.smallPadding),
            AvailabilityInfoModel(place: place),
            SpaceModel(space: linkTopOffset),
            FormLinkModel(feedbackForm: feedbackForm),
            SpaceModel(space: Constants.smallPadding),
            GraphHeaderModel(),
            SpaceModel(space: Constants.smallPadding),
            DaySelectionModel(selectedWeekday: selectedWeekday, weekdays: weekdays),
            SpaceModel(space: Constants.mediumPadding),
            GraphModel(description: description, densityMap: densityMap, selectedHour: selectedHour),
            SpaceModel(space: Constants.mediumPadding),
            HoursHeaderModel(weekday: weekday, date: date),
            SpaceModel(space: Constants.smallPadding),
            HoursModel(hours: hours),
            SpaceModel(space: Constants.smallPadding),
            MealFiltersModel(meals: meals, selectedMeal: selectedMeal),
            SpaceModel(space: Constants.smallPadding),
            MenuModel(menu: menus, mealNames: meals, selectedMeal: selectedMeal)
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
        } else if object is DaySelectionModel {
            let daySelectionModel = object as! DaySelectionModel
            return DaySelectionSectionController(daySelectionModel: daySelectionModel, delegate: self)
        } else if object is GraphHeaderModel {
            let graphHeaderModel = object as! GraphHeaderModel
            return GraphHeaderSectionController(graphHeaderModel: graphHeaderModel)
        } else if object is GraphModel {
            let graphModel = object as! GraphModel
            return GraphSectionController(graphModel: graphModel, delegate: self)
        } else if object is HoursHeaderModel {
            let hoursHeaderModel = object as! HoursHeaderModel
            return HoursHeaderSectionController(hoursHeaderModel: hoursHeaderModel)
        } else if object is HoursModel {
            let hoursModel = object as! HoursModel
            return HoursSectionController(hoursModel: hoursModel)
        } else if object is MenuModel {
            let menuModel = object as! MenuModel
            return MenuSectionController(menuModel: menuModel, delegate: self)
        } else if object is AvailabilityInfoModel {
            let availabilityModel = object as! AvailabilityInfoModel
            return AvailabilityInfoSectionController(availabilityModel: availabilityModel)
        } else if object is MealFiltersModel {
            let mealFiltersModel = object as! MealFiltersModel
            return MealsFilterSectionController(mealModel: mealFiltersModel, delegate: self)
        } else {
            let availabilityHeaderModel = object as! AvailabilityHeaderModel
            return AvailabilityHeaderSectionController(headerModel: availabilityHeaderModel)
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

extension PlaceDetailViewController: MealsFilterSectionControllerDelegate {

    func menuFilterViewDidSelectFilter(selectedMeal: Meal) {
        self.selectedMeal = selectedMeal
        adapter.performUpdates(animated: false, completion: nil)
    }

}

extension PlaceDetailViewController: DaySelectionSectionControllerDelegate {

    func daySelectionSectionControllerDidSelectWeekday(selectedWeekday: Int) {
        if selectedWeekday != self.selectedWeekday {
            self.selectedWeekday = selectedWeekday
            getDensityMap()
            adapter.performUpdates(animated: false, completion: nil)
        }
    }

}

extension PlaceDetailViewController: MenuSectionControllerDelegate {

    func menuSectionControllerDidChangeSelectedMeal(meal: Meal) {
        self.selectedMeal = meal
        adapter.performUpdates(animated: false, completion: nil)
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
