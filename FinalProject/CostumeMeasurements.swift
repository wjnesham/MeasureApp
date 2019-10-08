//
//  Measurement.swift
//  FinalProject
//
//  Created by William Nesham on 7/18/18.
//  Copyright © 2018 UMSL. All rights reserved.
//

import UIKit

class CostumeMeasurements: NSObject, NSCoding {
    
    var title: String
    var subTitle: String?
    
    var headCircumference: Double
    var wristCircumference: Double
    var tricepCircumference: Double
    var shoeSize: Double
    
    var userNotes: String?
    let dateCreated: Date
    
    init(title: String, subtitle: String?, head: Double?, wrist: Double?, tricep: Double?, shoe: Double?, userNotes: String?) {
        self.title = title
        self.subTitle = subtitle ?? "Some type of costume."
        self.headCircumference = head ?? 0.0
        self.wristCircumference = wrist ?? 0.0
        self.tricepCircumference = tricep ?? 0.0
        self.shoeSize = shoe ?? 0.0
        self.userNotes = userNotes ?? "Additional Measurements or Notes:"
        self.dateCreated = Date()
        
        super.init()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let title: String = aDecoder.decodeObject(forKey: "title") as! String
        let subTitle = aDecoder.decodeObject(forKey: "subTitle") as? String
        let headCircumference = aDecoder.decodeDouble(forKey: "headCircumference")
        let wristCircumference = aDecoder.decodeDouble(forKey: "wristCircumference")
        let tricepCircumference = aDecoder.decodeDouble(forKey: "tricepCircumference")
        let shoeSize = aDecoder.decodeDouble(forKey: "shoeSize")
        let userNotes = aDecoder.decodeObject(forKey: "userNotes") as? String
        self.init(title: title, subtitle: subTitle, head: headCircumference, wrist: wristCircumference, tricep: tricepCircumference, shoe: shoeSize, userNotes: userNotes)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.subTitle, forKey: "subTitle")
        aCoder.encode(self.headCircumference, forKey: "headCircumference")
        aCoder.encode(self.wristCircumference, forKey: "wristCircumference")
        aCoder.encode(self.tricepCircumference, forKey: "tricepCircumference")
        aCoder.encode(self.shoeSize, forKey: "shoeSize")
        aCoder.encode(self.userNotes, forKey: "userNotes")
    }
}



