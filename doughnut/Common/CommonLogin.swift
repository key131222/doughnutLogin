


import Foundation
import UIKit

func executeTaskLogin(_ url_server: URL, _ jsonData: Data, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    // 將輸出資料列印出來除錯用
    print("output: \(String(data: jsonData, encoding: .utf8)!)")
    var request = URLRequest(url: url_server)
    request.httpMethod = "POST"
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
    request.httpBody = jsonData
    let session = URLSession.shared
    let task = session.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
}

//記錄打上的帳號密碼
func saveUser(_ user: User) {
    if let jsonData = try? JSONEncoder().encode(user) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(jsonData, forKey: "user")
    }
}

func clearUser() {
    let userDefaults = UserDefaults.standard
    userDefaults.set(nil, forKey: "user")
}

func loadUser() -> User? {
    let userDefaults = UserDefaults.standard
    if let jsonData = userDefaults.data(forKey: "user") {
        if let user = try? JSONDecoder().decode(User.self, from: jsonData) {
            return user
        }
    }
    return nil
}
