//
//  CostumeModel.swift
//  FinalProject
//
//  Created by William Nesham on 7/19/18.
//  Copyright © 2018 UMSL. All rights reserved.
//

import UIKit

protocol CostumesModelDelegate: class {
    func dataUpdated()

}

class CostumeModel {
    
    weak var delegate: CostumesModelDelegate?
    
    var selectedRow = 0

    init() {
        delegate?.dataUpdated()
    }
    
    //Gets stored data
    func getDecodedCostumes() -> [CostumeMeasurements] {
        //Decode stored data
        if let decoded = UserDefaults.standard.object(forKey: "Costumes") as? Data, let decodedCostumes = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [CostumeMeasurements] {
            
            return decodedCostumes
        } else {
            return []
        }
    }
    
    // Get costume strings as arrays of Strings
    func getTitles() -> [String]? {
        
        var costumeTitles: [String] = []
        //Get stored data
        let decodedCostumes: [CostumeMeasurements] = getDecodedCostumes()
        
        for costume in decodedCostumes {
            costumeTitles.append(costume.title)
        }
        
        return costumeTitles
    }
    
    func getSubtitles() -> [String] {
        
        var costumeSubtitles: [String] = []
        //Get stored data
        let decodedCostumes = getDecodedCostumes()
        
        for costume in decodedCostumes {
            costumeSubtitles.append(costume.subTitle ?? "")
        }
        
        return costumeSubtitles
    }
}


// A safe way to access array elements
extension Array {
    func element(at index: Int) -> Element? {
        if index < 0 || index >= self.count { return nil }
        return self[index]
    }
}




