//
//  Legistlator.swift
//  GregsonRaevan_CE10
//
//  Created by Raevan Gregson on 12/17/16.
//  Copyright © 2016 Raevan Gregson. All rights reserved.
//

import Foundation
import UIKit

class Legistlator{
    
    var fullName:String?
    var bioGuide:String?
    var party:String?
    var title:String?
    var state:String?
    var image:UIImage?
    
    
    init(fullName:String,bioGuide:String,party:String,title:String,state:String){
        self.fullName = fullName
        self.party = party
        self.title = title
        self.state = state
        self.bioGuide = bioGuide
    }
    init(fullName:String,party:String,title:String,state:String,image:UIImage){
        self.fullName = fullName
        self.party = party
        self.title = title
        self.state = state
        self.image = image
    }
    init(){
    }
}
