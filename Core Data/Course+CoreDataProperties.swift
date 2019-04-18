//
//  Course+CoreDataProperties.swift
//  Core Data
//
//  Created by Archisman Banerjee on 17/04/19.
//  Copyright © 2019 Archisman Banerjee. All rights reserved.
//
//

import Foundation
import CoreData

extension Course
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course>
    {
        return NSFetchRequest<Course>(entityName: "Course")
    }

    @NSManaged public var couseName: String?
    @NSManaged public var courseId: Int32
    @NSManaged public var relationshipWithStudent: NSSet?
}

// MARK: Generated accessors for relationshipWithStudent
extension Course
{
    @objc(addRelationshipWithStudentObject:)
    @NSManaged public func addToRelationshipWithStudent(_ value: Student)

    @objc(removeRelationshipWithStudentObject:)
    @NSManaged public func removeFromRelationshipWithStudent(_ value: Student)

    @objc(addRelationshipWithStudent:)
    @NSManaged public func addToRelationshipWithStudent(_ values: NSSet)

    @objc(removeRelationshipWithStudent:)
    @NSManaged public func removeFromRelationshipWithStudent(_ values: NSSet)
}
