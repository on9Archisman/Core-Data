//
//  Student+CoreDataProperties.swift
//  Core Data
//
//  Created by Archisman Banerjee on 17/04/19.
//  Copyright © 2019 Archisman Banerjee. All rights reserved.
//
//

import Foundation
import CoreData

extension Student
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student>
    {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var mobile: Int64
    @NSManaged public var dob: NSDate?
    @NSManaged public var relationshipWithCourse: NSSet?
}

// MARK: Generated accessors for relationshipWithCourse
extension Student
{
    @objc(addRelationshipWithCourseObject:)
    @NSManaged public func addToRelationshipWithCourse(_ value: Course)

    @objc(removeRelationshipWithCourseObject:)
    @NSManaged public func removeFromRelationshipWithCourse(_ value: Course)

    @objc(addRelationshipWithCourse:)
    @NSManaged public func addToRelationshipWithCourse(_ values: NSSet)

    @objc(removeRelationshipWithCourse:)
    @NSManaged public func removeFromRelationshipWithCourse(_ values: NSSet)

}
