

import UIKit

class RegisterViewController: UIViewController , UITextFieldDelegate{
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfTax: UITextField!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func back(_ sender: Any) {
        DispatchQueue.main.async {
            let NextPage
                = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
   
            NextPage.modalPresentationStyle = .fullScreen
            self.present(NextPage, animated: true, completion: nil)
        }
    }
    
    @IBAction func registerInsert(_ sender: Any) {
        
        let mem_name = tfName.text == nil ? "" : tfName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let mem_password = tfPassword.text == nil ? "" : tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let mem_email = tfEmail.text == nil ? "" : tfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let mem_phone = tfPhone.text == nil ? "" : tfPhone.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let mem_tax = tfTax.text == nil ? "" :
            tfTax.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
 
        //還要寫空的不要傳值
         
        let member = Member(mem_name: mem_name, mem_password: mem_password, mem_email: mem_email, mem_phone: mem_phone, mem_tax: mem_tax, mem_state: 1)
        
        var requestParam = [String: String]()
        requestParam["action"] = "insert"
        requestParam["member"] = try! String(data: JSONEncoder().encode(member), encoding: .utf8)
        
        func executeTaskRegister(_ url_server: URL, _ requestParam: [String: Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
            // requestParam值為Any就必須使用JSONSerialization.data()，而非JSONEncoder.encode()
            let jsonData = try! JSONSerialization.data(withJSONObject: requestParam)
            var request = URLRequest(url: url_server)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
            request.httpBody = jsonData
            let sessionData = URLSession.shared
            let task = sessionData.dataTask(with: request, completionHandler: completionHandler)
            task.resume()
        }
        
      if tfPassword.text?.isEmpty == true {
            let controller = UIAlertController(title: "註冊未輸入完成", message: "請確認您是否有未輸入的項目。", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)

        }
        else{
            
            //有打密碼才傳到SQL
            executeTaskRegister(url_server!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        if let result = String(data: data!, encoding: .utf8) {
                            if let count = Int(result) {
                                DispatchQueue.main.async {
                                    // 新增成功則回前頁
                                    if count != 0 {
                                        
                                        //註冊成功回首頁
                                        let controller = UIAlertController(title: "註冊", message: "註冊成功！", preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "確認", style: .default) { (_) in
                                            let NextPage
                                                = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                            
                                            NextPage.modalPresentationStyle = .fullScreen
                                            self.present(NextPage, animated: true, completion: nil)
                                        }
                                        
                                        controller.addAction(okAction)
                                    
                                        self.present(controller, animated: true, completion: nil)
                                        
                                        //還要寫有值才傳
                                        
                                    } else {
                                        self.label.text = "insert fail"
                                    }
                                }
                            }
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
    }
    
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    //點空白處讓鍵盤消失
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
