//
//  GymDetailViewController.swift
//  Campus Density
//
//  Created by Ansh Godha on 15/02/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit
import IGListKit

enum EquipmentType: String, CaseIterable {
    case none = "No"
    case cardio = "Cardio"
    case weights = "Weights"
}

class GymDetailViewController: UIViewController, UIScrollViewDelegate {
    var collectionView: UICollectionView!
    var adapter: ListAdapter!
    var selectedType: EquipmentType = .cardio
    var equipmentTypes = [EquipmentType]()

    override func viewDidLoad() {
        setupViews()
    
    }

    func setupViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isHidden = false
        collectionView.alwaysBounceVertical = true
        collectionView.bounces = true
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let updater = ListAdapterUpdater()
        adapter = ListAdapter(updater: updater, viewController: nil, workingRangeSize: 1)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self

        adapter.performUpdates(animated: false, completion: nil)
        super.viewDidLoad()
    }
}

extension GymDetailViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        for type in EquipmentType.allCases {
            if !equipmentTypes.contains(type) && type.rawValue != "No" {
                equipmentTypes.append(type)
            }
        }
        return [
            //This is hardcoded for now
            GymFiltersModel(equipmentTypes: equipmentTypes, selectedEquipmentType: selectedType),
            //GymDensityModel(currentCardioCount: 5, maxCardioCount: 10, currentWeightCount: 30)
        ]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
       
        return GymFilterSectionController(equipmentModel: object as! GymFiltersModel, delegate: self)
        
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension GymDetailViewController: GymFiltersSectionControllerDelegate {
    func gymFilterViewDidSelectEquipment(selectedEquipmentType: EquipmentType) {
        self.selectedType = selectedEquipmentType
        print(self.selectedType)
        adapter.performUpdates(animated: false, completion: nil)
    }
    
    
}
