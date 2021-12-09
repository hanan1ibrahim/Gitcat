//
//  SavedUsers+CoreDataProperties.swift
//  
//
//
//  Created by Hanan Ibrahim on 07/12/2021.
//

import Foundation
import CoreData


extension SavedUsers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedUsers> {
        return NSFetchRequest<SavedUsers>(entityName: "SavedUsers")
    }

    @NSManaged public var userAvatar: String?
    @NSManaged public var userName: String?
    @NSManaged public var userURL: String?

}
