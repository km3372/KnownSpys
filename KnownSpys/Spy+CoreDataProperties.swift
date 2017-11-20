import Foundation
import CoreData


extension Spy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Spy> {
        return NSFetchRequest<Spy>(entityName: "Spy")
    }

    @NSManaged public var age: Int64
    @NSManaged public var gender: String
    @NSManaged public var imageName: String
    @NSManaged public var isIncognito: Bool
    @NSManaged public var name: String
    @NSManaged public var password: String

}
