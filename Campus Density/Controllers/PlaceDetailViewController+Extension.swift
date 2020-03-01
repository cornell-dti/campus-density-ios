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
        var menus = DayMenus(menus: [], date: "help")
        if let selectedWeekdayHours = place.hours[selectedWeekday] {
            hours = selectedWeekdayHours
        }
        var menuDay = selectedWeekday + 1 - getWeekday()
        if (menuDay < 0) {
            menuDay = 7 + menuDay
        }
        if (menuDay == 0) {
            menuDay = 7
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
            SpaceModel(space: Constants.largePadding),
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
        } else if object is GraphHeaderModel {
            let graphHeaderModel = object as! GraphHeaderModel
            return GraphHeaderSectionController(graphHeaderModel: graphHeaderModel, delegate: self)
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
        } else {
            let mealFiltersModel = object as! MealFiltersModel
            return MealsFilterSectionController(mealModel: mealFiltersModel, delegate: self)
        }
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }

    func getIndexOfSelectedMeal() -> Int {
        var index = -1
        for i in (0 ..< mealList.count) {
            if mealList[i] == self.selectedMeal {
                index = i
                break
            }
        }
        return index
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

extension PlaceDetailViewController: GraphHeaderSectionControllerDelegate {

    func graphHeaderSectionControllerDidSelectWeekday(selectedWeekday: Int) {
        if selectedWeekday != self.selectedWeekday {
            self.selectedWeekday = selectedWeekday
            getDensityMap()
            adapter.performUpdates(animated: false, completion: nil)
        }
    }

}

extension PlaceDetailViewController: MenuSectionControllerDelegate {
    func menuSectionControllerDidSwipeRightOnMenuLabel() {

        let index = getIndexOfSelectedMeal()
        if index < mealList.count - 1 {
            self.selectedMeal = mealList[index+1]
            adapter.performUpdates(animated: true, completion: nil)
        }
    }

    func menuSectionControllerDidSwipeLeftOnMenuLabel() {

        let index = getIndexOfSelectedMeal()
        if index > 0 {
            self.selectedMeal = mealList[index-1]
            adapter.performUpdates(animated: true, completion: nil)
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
