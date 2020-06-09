import UIKit

//登入資訊
struct LoginUser: Codable {
    var mem_email: String
    var mem_password: String
}
//登入頁面
class LoginVC: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        //自動讀取登入成功時儲存的帳號密碼
        if let user = loadUser() {
            tfEmail.text = user.mem_email
            tfPassword.text = user.mem_password
        }
    }
    
    //按鈕設定
    @IBAction func cleanEmail(_ sender: Any) {
        tfEmail.text = ""
    }
    @IBAction func cleanPassword(_ sender: Any) {
        tfPassword.text = ""
    }
    @IBAction func clickLogin(_ sender: Any) {
        let mem_email = tfEmail.text == nil ? "" :
            tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let mem_password = tfPassword.text == nil ? "" : tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if mem_email!.isEmpty && mem_password!.isEmpty {
            textView.text = "您尚未輸入電子信箱及密碼。"
            return
        }
        if mem_email!.isEmpty  {
            textView.text = "您尚未輸入電子信箱。"
            return
        }
        if mem_password!.isEmpty {
            textView.text = "您尚未輸入密碼。"
            return
        }
        
        //確認帳號密碼是否跟資料庫內容相同
        let user = LoginUser(mem_email: mem_email!, mem_password: mem_password!)
        var requestParam = [String: String]()
        requestParam["action"] = "login"
        requestParam["user"] = try! String(data: JSONEncoder().encode(user), encoding: .utf8)
        
        if let jsonData = try? JSONEncoder().encode(requestParam) {
            executeTaskLogin(url_server!, jsonData) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        if let result = try? JSONDecoder().decode([String: Bool].self, from: data!) {
                            //如果從伺服器回傳成功, 傳入'result'
                            if result["result"]! {
                                //確認成功後, 儲存至saveUser
                                saveUser(user)
                                print("result: \(result["result"]!)")
                                //成功後跳轉頁面
                                DispatchQueue.main.async {
                                    let NextPage
                                        = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
                                    NextPage.modalPresentationStyle = .fullScreen
                                    self.present(NextPage, animated: true, completion: nil)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.textView.text = "請輸入正確的信箱及密碼。"
                                    return
                                }
                            }
                            print(result)
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
    }
    //隱藏小鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
