//
//  GymsViewController.swift
//  Campus Density
//
//  Created by Ansh Godha on 24/11/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import UIKit
import IGListKit

class GymsViewController: UIViewController, UIScrollViewDelegate {

    var collectionView: UICollectionView!
    var adapter: ListAdapter!

    override func viewDidLoad() {
        super.viewDidLoad()
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

extension GymsViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [

        ]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        //TODO: CHANGE!!
        return GymDensitySectionController(densityModel: object as! GymDensityModel)
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
