//
//  UserDefaultsManager.swift
//  Moodyngs
//
//  Created by Roman Gorbenko on 29/10/22.
//

import Foundation

/*
 
 //How to use
 UserDefaultsManager.shared.set(true, forKey: .admin)
 let isAdminEnable = UserDefaultsManager.shared.get(objectForkey: .admin, type: Bool.self)
 print(isAdminEnable)
 
 UserDefaultsManager.shared.purge()
 print(UserDefaultsManager.shared.get(objectForkey: .admin, type: Bool.self))
 
 */

/// UserDefaultsManager is a manager and wrapper class for UserDefaults that use for persistance key-value store, optimized for storing user settings.
/// Key-Value Store: NSUserDefaults stores Property List objects (NSString, NSData, NSNumber, NSDate, NSArray, and NSDictionary) identified by NSString keys, similar to an NSMutableDictionary.
/// Optimized for storing user settings: NSUserDefaults is intended for relatively small amounts of data, queried very frequently, and modified occasionally. Using it in other ways may be slow or use more memory than solutions more suited to those uses.
class UserDefaultsManager: NSObject {
    /// static shared instance Initializes  of `self` with default strategies.
    static let shared = UserDefaultsManager()
    let userDefaults: UserDefaults?
    
    /// Initializes  private`self` with default strategies.
    private override init() {
        userDefaults = UserDefaults.standard
    }
    /// -removeObjectForKey: is equivalent to -[... setObject:nil forKey:defaultName]
    func remove(for key: UserDefaultsKeys) {
        userDefaults?.removeObject(forKey: key.value)
    }
    
    func purge() {
        let keys = UserDefaultsKeys.allCases//UserDefaultsKeys.reteriveAllCases()
        keys.forEach {
            let excluded = UserDefaultsKeys.excludedCases.contains($0)
            if excluded {
                print("excluded case:\($0.value)")
            } else {
                remove(for: $0)
            }
        }
        //KeyChainWrapper.share.deletePassword()
    }
    
}

extension UserDefaultsManager {
    
    /// set value:forKey: immediately stores a value (or removes the value if nil is passed as the value) for the provided key in the search list entry for the receiver's suite name in the current user and any host, then asynchronously stores the value persistently, where it is made available to other processes.
    /// - Parameters:
    ///   - value: value of any Object confirm to Encodable Protocol
    ///   - key: String value assocaited with stored object
    func set<T>(_ value: T?, forKey key: UserDefaultsKeys) where T: Encodable {
        guard let tempValue = value else {
            userDefaults?.set(nil, forKey: key.value)
            return
        }
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(tempValue) else {
            userDefaults?.set(nil, forKey: key.value)
            return
        }
        let json = String(data: jsonData, encoding: .utf8)
        userDefaults?.set(json, forKey: key.value)
    }
    
    /// Retrive Object assocaited with key
    /// - Parameters:
    ///   - key: UserDefaultsKeys value that use to store value as reference
    ///   - type: Type of object that conform Decodable Protocol
    func get<T: Decodable>(objectForkey key: UserDefaultsKeys, type: T.Type) -> T? {
        let jsonString = getObject(key.value) as? String
        let jsonData = jsonString?.data(using: .utf8)
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: jsonData ?? Data())
    }
    
    /**
     -set bool:forKey: immediately stores a value  for the provided key in the search list entry for the receiver's suite name in the current user and any host, then asynchronously stores the value persistently, where it is made available to other processes.
     */
    func set(bool: Bool, for key: UserDefaultsKeys) {
        userDefaults?.set(bool, forKey: key.value)
    }
    
    /// Retrive Bool assocaited with key
    /// - Parameter key: UserDefaultsKeys enum
    func get(for key: UserDefaultsKeys) -> Bool? {
        let result = userDefaults?.bool(forKey: key.value)
        return result
    }
}

extension UserDefaultsManager {
    /// Retrive Object assocaited with key
    /// - Parameter key: UserDefaultsKeys value that use to store value as reference
    private func getObject(_ key: String) -> Any? {
        return userDefaults?.object(forKey: key)
    }
}

enum UserDefaultsKeys: String, CaseIterable {
    
    case user = "user"
    
    // Helper
    static var excludedCases: [UserDefaultsKeys] = [.user]
    
    var value : String {
        return self.rawValue
    }
}
    
