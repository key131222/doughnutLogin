

import UIKit


class LoginViewController: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var loginNext: UIBarButtonItem!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let user = loadUser() {
            tfEmail.text = user.mem_email
            tfPassword.text = user.mem_password
        }
    }

    

    @IBAction func clickLogin(_ sender: Any) {
        let email = tfEmail.text == nil ? "" :
            tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = tfPassword.text == nil ? "" : tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if email!.isEmpty || password!.isEmpty {
            textView.text = "user name or password is invalid"
            return
        }
        
        let user = User(email!, password!)
        
        var requestParam = [String: String]()
        requestParam["action"] = "login"
        requestParam["user"] = try! String(data: JSONEncoder().encode(user), encoding: .utf8)
        
        
        if let jsonData = try? JSONEncoder().encode(requestParam) {
            
            executeTaskLogin(url_server!, jsonData) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        if let result = try? JSONDecoder().decode([String: Bool].self, from: data!) {
                            // server驗證帳密成功會回傳true
                            if result["result"]! {
                                // 驗證成功的帳密存入UserDefaults
                                saveUser(user)
                                print("result: \(result["result"]!)")
                                // 開啟下一頁
                           
                                
                                DispatchQueue.main.async {
                                    let NextPage
                                        = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
                               
                                    NextPage.modalPresentationStyle = .fullScreen
                                    self.present(NextPage, animated: true, completion: nil)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.textView.text = "請輸入正確的帳號密碼。"
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
    
      //點空白處收鍵盤
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
       }
}
