//
//  GymDetailViewController.swift
//  Campus Density
//
//  Created by Ansh Godha on 15/02/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit
import IGListKit

class GymDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension GymDetailViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [
            //This is hardcoded for now
            GymDensityModel(currentCardioCount: 5, maxCardioCount: 10, currentWeightCount: 30)
        ]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is GymDensityModel {
            return GymDensitySectionController(densityModel: object as! GymDensityModel)
        }
        
        //temporary stub
        return GymDensitySectionController(densityModel: object as! GymDensityModel)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    
}
