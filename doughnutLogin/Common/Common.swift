import UIKit
//連接Server
let common_url = "http://172.20.10.11:8080/doughnut/"
let url_server = URL(string: common_url + "UserServlet")

//將登入註冊輸出的資料印出
func executeTaskLogin(_ url_server: URL, _ jsonData: Data, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    print("output: \(String(data: jsonData, encoding: .utf8)!)")
    var request = URLRequest(url: url_server)
    request.httpMethod = "POST"
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
    request.httpBody = jsonData
    let session = URLSession.shared
    let task = session.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
}
func executeTaskRegister(_ url_server: URL, _ requestParam: [String: Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    let jsonData = try! JSONSerialization.data(withJSONObject: requestParam)
    var request = URLRequest(url: url_server)
    request.httpMethod = "POST"
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
    request.httpBody = jsonData
    let sessionData = URLSession.shared
    let task = sessionData.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
}
//儲存登入成功的帳號密碼
func saveUser(_ user: LoginUser) {
    if let jsonData = try? JSONEncoder().encode(user) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(jsonData, forKey: "user")
    }
}
//讀取儲存的帳號密碼
func loadUser() -> LoginUser? {
    let userDefaults = UserDefaults.standard
    if let jsonData = userDefaults.data(forKey: "user") {
        if let user = try? JSONDecoder().decode(LoginUser.self, from: jsonData) {
            return user
        }
    }
    return nil
}
