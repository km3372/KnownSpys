import Foundation
import Outlaw

private var numImagesPerGender = 6

struct SpyDTO {
    var age: Int
    var name: String
    var gender: Gender
    var password: String
    var imageName: String = ""
    var isIncognito: Bool
}

extension SpyDTO: Deserializable {
    
    init(object: Outlaw.Extractable) throws {
        let genderString: String = try object.value(for: "gender")

        gender = Gender(rawValue: genderString) ?? .female
        
        age = try object.value(for: "age")
        name = try object.value(for: "name")
        password = try object.value(for: "password")
        isIncognito = try object.value(for: "isIncognito")
        imageName = randomImageName
    }
    
    var randomImageName: String {
        let imageIndex = Int(arc4random_uniform(UInt32(numImagesPerGender))) + 1
        let imageGender = gender == .female ? "F"
                                            : "M"

        return String(format: "Spy%@%02d", imageGender, imageIndex)
    }
}

extension SpyDTO: Serializable {
    func serialized() -> [String: Any] {
        return ["name": name,
                "age": age,
                "gender": gender,
                "password": password,
                "isIncognito": isIncognito,
                "imageName": imageName]
    }
}
