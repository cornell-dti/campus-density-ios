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
        objects.append(SpaceModel(space: Constants.smallPadding))
        objects.append(FiltersModel(filters: filters, selectedFilter: selectedFilter))
        objects.append(SpaceModel(space: Constants.smallPadding))
        objects.append(SearchBarModel())
        objects.append(SpaceModel(space: Constants.smallPadding))
        objects.append(PoliciesModel())
        objects.append(SpaceModel(space: Constants.smallPadding / 3))
        objects.append(contentsOf: filteredPlaces.map { place in PlaceModel(place: place) })
        objects.append(SpaceModel(space: Constants.smallPadding))
        objects.append(AppFeedbackModel())
        objects.append(SpaceModel(space: Constants.mediumPadding))
        objects.append(LastUpdatedTextModel(lastUpdated: lastUpdatedTime))
        objects.append(SpaceModel(space: Constants.smallPadding))
        objects.append(LogoModel(length: logoLength, link: dtiWebsite))
        objects.append(SpaceModel(space: Constants.smallPadding))
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is PlaceModel {
            let placeModel = object as! PlaceModel
            return PlaceSectionController(placeModel: placeModel, delegate: self)
        } else if object is SpaceModel {
            let spaceModel = object as! SpaceModel
            return SpaceSectionController(spaceModel: spaceModel)
        } else if object is FiltersModel {
            let filtersModel = object as! FiltersModel
            return FiltersSectionController(filtersModel: filtersModel, delegate: self)
        } else if object is LastUpdatedTextModel {
            let lastUpdatedTextModel = object as! LastUpdatedTextModel
            return LastUpdatedTextSectionController(lastUpdatedTextModel: lastUpdatedTextModel, style: .main)
        } else if object is AppFeedbackModel {
            let appFeedbackModel = object as! AppFeedbackModel
            return AppFeedbackSectionController(appFeedbackModel: appFeedbackModel, delegate: self)
        } else if object is LogoModel {
            let logoModel = object as! LogoModel
            return LogoSectionController(logoModel: logoModel, delegate: self)
        } else if object is SearchBarModel {
            let searchBarModel = object as! SearchBarModel
            return SearchBarSectionController(searchBarModel: searchBarModel, delegate: self)
        } else if object is PoliciesModel {
            let policiesModel = object as! PoliciesModel
            return PoliciesSectionController(policiesModel: policiesModel, delegate: self)
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
        updateFilteredPlaces()
        adapter.performUpdates(animated: false, completion: nil)
    }

}

extension PlacesViewController: PoliciesSectionControllerDelegate {
    func policiesSectionControllerDidPressPoliciesButton() {
        if let url = URL(string: diningPolicyURL), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension PlacesViewController: LogoSectionControllerDelegate {

    func logoSectionControllerDidTapLink(logoModel: LogoModel) {
        guard let url = URL(string: logoModel.link) else { return }
        UIApplication.shared.open(url)
    }

}

extension PlacesViewController: AppFeedbackSectionControllerDelegate {

    func appFeedbackSectionControllerDidTapLink() {
        homeFeedbackViewController.showWith()
    }
}

extension PlacesViewController: PlaceSectionControllerDelegate {

    func placeSectionControllerDidSelectPlace(id: String) {
        let placeDetailViewController = PlaceDetailViewController()
        placeDetailViewController.place = filteredPlaces.first(where: { $0.id == id })
        navigationController?.pushViewController(placeDetailViewController, animated: true)
    }

}

extension PlacesViewController: SearchBarSectionControllerDelegate {
    func searchBarDidUpdateSearchText(searchText: String) {
        self.searchText = searchText
        updateFilteredPlaces()
        adapter.performUpdates(animated: false, completion: nil)
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
