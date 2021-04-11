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
        let lastUpdatedTime = API.getLastUpdatedDensityTime()
        var menus = DayMenus(menus: [], date: "help")
        var menuDay = selectedWeekday + 1 - getCurrentWeekday()
        if menuDay <= 0 {
            menuDay = 7 + menuDay
        }
        if place.menus.weeksMenus.count != 0 {
            menus = place.menus.weeksMenus[menuDay]
        }
        var meals = [Meal]()
        var endTimes = [Int]()
        if menus.menus.count != 0 {
            for meal in menus.menus {
                if meal.menu.count != 0 {
                    meals.append(Meal(rawValue: meal.description)!)
                    endTimes.append(meal.endTime)
                }
            }

            self.mealList = meals

            if meals.count > 0 {
                spinnerView.isHidden = true
                unavailableLabel.isHidden = true
            } else {
                unavailableLabel.isHidden = false
                view.addSubview(unavailableLabel)
            }

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

        //if there are not any available menus for the day, the unavailable menu label is shown else it is hidden and the activity indicator spins until the menus load
        else if place.menus.weeksMenus.count == 0 {
            spinnerView.isHidden = false
            spinnerView.animate()
            view.addSubview(spinnerView)
        } else {
            unavailableLabel.isHidden = false
            view.addSubview(unavailableLabel)
        }

        return [
            DetailControllerHeaderModel(displayName: place.displayName, hours: place.hours),
            SpaceModel(space: Constants.smallPadding),
            AvailabilityHeaderModel(),
            SpaceModel(space: Constants.smallPadding),
            LastUpdatedTextModel(lastUpdated: lastUpdatedTime),
            SpaceModel(space: linkTopOffset),
            AvailabilityInfoModel(place: place), // TODO: look into only passing what's necessary
            SpaceModel(space: linkTopOffset),
            FormLinkModel(isClosed: place.isClosed, waitTime: place.waitTime),
            SpaceModel(space: Constants.mediumPadding),
            SectionDividerModel(lineWidth: dividerHeight),
            SpaceModel(space: Constants.mediumPadding),
            MenuHeaderModel(),
            SpaceModel(space: Constants.mlPadding),
            DaySelectionModel(selectedWeekday: selectedWeekday, weekdays: weekdays),
            SpaceModel(space: Constants.smallPadding),
            MealFiltersModel(meals: meals, selectedMeal: selectedMeal),
            SectionDividerModel(lineWidth: dividerHeight),
            SpaceModel(space: Constants.mediumPadding),
            MenuModel(menu: menus, mealNames: meals, selectedMeal: selectedMeal),
            SpaceModel(space: Constants.smallPadding)
        ]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is SpaceModel {
            let spaceModel = object as! SpaceModel
            return SpaceSectionController(spaceModel: spaceModel)
        } else if object is SectionDividerModel {
            let sectionDividerModel = object as! SectionDividerModel
            return SectionDividerSectionController(sectionDividerModel: sectionDividerModel)
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
        } else if object is MenuModel {
            let menuModel = object as! MenuModel
            return MenuSectionController(menuModel: menuModel, delegate: self)
        } else if object is AvailabilityInfoModel {
            let availabilityModel = object as! AvailabilityInfoModel
            return AvailabilityInfoSectionController(availabilityModel: availabilityModel)
        } else if object is MealFiltersModel {
            let mealFiltersModel = object as! MealFiltersModel
            return MealsFilterSectionController(mealModel: mealFiltersModel, delegate: self)
        } else if object is DetailControllerHeaderModel {
            let detailControllerHeaderModel = object as! DetailControllerHeaderModel
            return DetailControllerHeaderSectionController(detailControllerHeaderModel: detailControllerHeaderModel)
        } else if object is AvailabilityHeaderModel {
            let availabilityHeaderModel = object as! AvailabilityHeaderModel
            return AvailabilityHeaderSectionController(headerModel: availabilityHeaderModel)
        } else if object is LastUpdatedTextModel {
            let lastUpdatedTextModel = object as! LastUpdatedTextModel
            return LastUpdatedTextSectionController(lastUpdatedTextModel: lastUpdatedTextModel, style: .detail)
        } else {
            let menuHeaderModel = object as! MenuHeaderModel
            return MenuHeaderSectionController(menuHeaderModel: menuHeaderModel)
        }
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }

}

extension PlaceDetailViewController: FormLinkSectionControllerDelegate {

    func formLinkSectionControllerDidPressLinkButton() {
        feedbackViewController.showWith(location: place.id, predictedDensity: place.density.rawValue)
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
