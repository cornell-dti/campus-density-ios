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

        var diningHallMenus: DayMenus!
        var meals: [Meal]!

        switch place.facilityType {
        case .diningHall:
            spinnerView.isHidden = true
            var menuDay = selectedWeekday + 1 - getCurrentWeekday()
            if menuDay <= 0 {
                menuDay = 7 + menuDay
            }
            guard let diningMenus = place.diningMenus, menuDay < diningMenus.count else {
                print("This is not supposed to happen during normal operation, not enough menus returned!")
                unavailableLabel.isHidden = false
                view.addSubview(unavailableLabel)
                break
            }
            diningHallMenus = diningMenus[menuDay]
            meals = [Meal]()
            var endTimes = [Double]()
            if diningHallMenus.menus.count > 0 {
                for meal in diningHallMenus.menus {
                    if meal.menu.count != 0 {
                        meals.append(Meal(rawValue: meal.description)!)
                        endTimes.append(meal.endTime)
                    }
                }

                if meals.count > 0 {
                    unavailableLabel.isHidden = true
                } else {
                    unavailableLabel.isHidden = false
                    view.addSubview(unavailableLabel)
                }

                // Auto-select next meal if none selected/previous selection unavailable for this day
                if !meals.contains(selectedMeal) && meals.count > 0 {
                    let currentTime = Date().timeIntervalSince1970
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
            // If there are not any available menus for THIS day, the unavailable menu label is shown
            else {
                unavailableLabel.isHidden = false
                view.addSubview(unavailableLabel)
            }

        case .cafe:
            spinnerView.isHidden = true

        // Still waiting on /menuData to complete and return menus and facility type, so show spinner
        case .none:
            spinnerView.isHidden = false
            spinnerView.animate()
            view.addSubview(spinnerView)
        }

        var objects = [ListDiffable]()

        objects.append(DetailControllerHeaderModel(displayName: place.displayName, hours: place.hours))
        objects.append(SpaceModel(space: Constants.smallPadding))
        objects.append(AvailabilityHeaderModel())
        objects.append(SpaceModel(space: Constants.smallPadding))
        objects.append(LastUpdatedTextModel(lastUpdated: lastUpdatedTime))
        objects.append(SpaceModel(space: linkTopOffset))
        objects.append(AvailabilityInfoModel(place: place)) // TODO: look into only passing what's necessary
        objects.append(SpaceModel(space: linkTopOffset))
        objects.append(FormLinkModel(isClosed: place.isClosed, waitTime: place.waitTime))
        objects.append(SpaceModel(space: Constants.mediumPadding))
        objects.append(SectionDividerModel(lineWidth: dividerHeight))
        objects.append(SpaceModel(space: Constants.mediumPadding))
        switch place.facilityType {
        case .diningHall:
            objects.append(MenuHeaderModel(showDetails: true))
            objects.append(SpaceModel(space: Constants.smallPadding))
            objects.append(DaySelectionModel(selectedWeekday: selectedWeekday, weekdays: weekdays))
            objects.append(SpaceModel(space: Constants.smallPadding))
            objects.append(MealFiltersModel(meals: meals, selectedMeal: selectedMeal))
            objects.append(SectionDividerModel(lineWidth: dividerHeight))
            objects.append(SpaceModel(space: Constants.mediumPadding))
            objects.append(MenuModel(diningHallMenu: diningHallMenus, mealNames: meals, selectedMeal: selectedMeal))
        case .cafe:
            objects.append(MenuHeaderModel(showDetails: false))
            objects.append(SpaceModel(space: Constants.smallPadding))
            if !place.hours.isEmpty {
                let hours = place.hours[0].dailyHours
                objects.append(MenuModel(cafeMenu: place.cafeMenus!, startTime: hours.startTimestamp, endTime: hours.endTimestamp))
            }
        case .none:
            break
        }
        objects.append(SpaceModel(space: Constants.smallPadding))
        return objects
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
