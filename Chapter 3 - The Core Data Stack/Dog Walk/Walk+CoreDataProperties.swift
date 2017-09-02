//
//  Walk+CoreDataProperties.swift
//  Dog Walk
//
//  Created by Paweł Liczmański on 02.09.2017.
//  Copyright © 2017 Razeware. All rights reserved.
//

import Foundation
import CoreData


extension Walk {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Walk> {
        return NSFetchRequest<Walk>(entityName: "Walk")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var dog: Dog?

}
