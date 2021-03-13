//
//  Results+CoreDataProperties.swift
//  CoredataDemo
//
//  Created by developer on 20/02/21.
//
//

import Foundation
import CoreData


extension Results {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Results> {
        return NSFetchRequest<Results>(entityName: "Results")
    }

    @NSManaged public var artistName: String?
    @NSManaged public var artworkUrl100: String?

}

extension Results : Identifiable {

}
