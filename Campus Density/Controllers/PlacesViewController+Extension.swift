//
//  EateriesViewController+Extension.swift
//  Campus Density
//
//  Created by Matthew Coufal on 10/14/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit
import IGListKit

extension PlacesViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        if collectionView.isHidden { return [] }
        let lastUpdatedTime = API.getLastUpdatedDensityTime()
        var objects = [ListDiffable]()
        objects.append(FiltersModel(filters: filters, selectedFilter: selectedFilter))
        objects.append(SearchBarModel(searchText: ""))
        objects.append(contentsOf: filteredPlaces)
        objects.append(SpaceModel(space: Constants.smallPadding))
        objects.append(LastUpdatedTextModel(lastUpdated: lastUpdatedTime))
        objects.append(SpaceModel(space: Constants.smallPadding))
        objects.append(LogoModel(length: logoLength, link: dtiWebsite))
        objects.append(SpaceModel(space: Constants.smallPadding))
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is Place {
            let place = object as! Place
            return PlaceSectionController(place: place, delegate: self)
        } else if object is SpaceModel {
            let spaceModel = object as! SpaceModel
            return SpaceSectionController(spaceModel: spaceModel)
        } else if object is FiltersModel {
            let filtersModel = object as! FiltersModel
            return FiltersSectionController(filtersModel: filtersModel, delegate: self)
        } else if object is LastUpdatedTextModel {
            let lastUpdatedTextModel = object as! LastUpdatedTextModel
            return LastUpdatedTextSectionController(lastUpdatedTextModel: lastUpdatedTextModel)
        } else if object is LogoModel {
            let logoModel = object as! LogoModel
            return LogoSectionController(logoModel: logoModel, delegate: self)
        } else if object is SearchBarModel {
            let searchBarModel = object as! SearchBarModel
            return SearchBarSectionController(searchBarModel: searchBarModel, delegate: self)
        }
        return ListSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }

}

extension PlacesViewController: FiltersSectionControllerDelegate {

    func filtersSectionControllerDidSelectFilter(selectedFilter: Filter) {
        self.selectedFilter = selectedFilter
        filter(by: selectedFilter)
        adapter.performUpdates(animated: false, completion: nil)
    }

}

extension PlacesViewController: LogoSectionControllerDelegate {

    func logoSectionControllerDidTapLink(logoModel: LogoModel) {
        guard let url = URL(string: logoModel.link) else { return }
        UIApplication.shared.open(url)
    }

}

extension PlacesViewController: PlaceSectionControllerDelegate {

    func placeSectionControllerDidSelectPlace(place: Place) {
        let placeDetailViewController = PlaceDetailViewController()
        placeDetailViewController.place = place
        navigationController?.pushViewController(placeDetailViewController, animated: true)
    }

}

extension PlacesViewController: SearchBarSectionControllerDelegate {
    func searchBarDidUpdateSearchText(searchText: String) {
        print(searchText)
    }
}

extension String {

    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)

        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }

    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

}
