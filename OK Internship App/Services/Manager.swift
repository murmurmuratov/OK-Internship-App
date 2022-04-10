import Foundation

class Manager {
    
    enum SettingKeys: String {
        case users
        case activeUser
    }
    
    static let shared = Manager()
    
    let defaults = UserDefaults.standard
    let userKey = SettingKeys.users.rawValue
    let activeUserKey = SettingKeys.activeUser.rawValue
    
    var users: [User] {
        get {
            if let data = defaults.value(forKey: userKey) as? Data {
                return try! PropertyListDecoder().decode([User].self, from: data)
            } else {
                return [User]()
            }
        }
        
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: userKey)
            }
        }
    }
    
    var activeUser: User? {
        get {
            if let data = defaults.value(forKey: activeUserKey) as? Data {
                return try! PropertyListDecoder().decode(User.self, from: data)
            } else {
                return nil
            }
        }
        
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: activeUserKey)
            }
        }
    }
    
    func saveUser(email: String, password: String) {
        
        let user = User(email: email, password: password)
        users.insert(user, at: 0)
    }
    
    func saveActiveUser(user: User) {
        activeUser = user
    }
    
    func findUserDataBase(email: String) -> User? {
        for user in users {
            if user.email == email {
                return user
            }
        }
        return nil
    }
}
