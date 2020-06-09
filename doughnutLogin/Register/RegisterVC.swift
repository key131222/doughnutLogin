import UIKit

//註冊填入的資訊
struct RegisterMember: Codable {
    var mem_name: String
    var mem_password: String
    var mem_email: String?
    var mem_phone: String?
    var mem_tax: String?
    var mem_state: Int
}
//註冊頁面
class RegisterVC: UIViewController , UITextFieldDelegate{
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfTax: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func back(_ sender: Any) {
        DispatchQueue.main.async {
            let NextPage
                = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            NextPage.modalPresentationStyle = .fullScreen
            self.present(NextPage, animated: true, completion: nil)
        }
    }
    //註冊規則設定
    @IBAction func registerInsert(_ sender: Any) {
        let mem_name = tfName.text == nil ? "" : tfName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let mem_password = tfPassword.text == nil ? "" : tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let mem_email = tfEmail.text == nil ? "" : tfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let mem_phone = tfPhone.text == nil ? "" : tfPhone.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let mem_tax = tfTax.text == nil ? "" :
            tfTax.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let member = RegisterMember(mem_name: mem_name, mem_password: mem_password, mem_email: mem_email, mem_phone: mem_phone, mem_tax: mem_tax, mem_state: 1)
        //傳送至Server
        var requestParam = [String: String]()
        requestParam["action"] = "insert"
        requestParam["member"] = try! String(data: JSONEncoder().encode(member), encoding: .utf8)
        
        //註冊格式規則確認
        if tfName.text?.isEmpty == true || tfPassword.text?.isEmpty == true || tfEmail.text?.isEmpty == true || tfPhone.text?.isEmpty == true ||  tfPassword.text?.isEmpty == true{
            let controller = UIAlertController(title: "註冊未輸入完成。", message: "請確認您是否有未輸入的項目。", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
        else{
            executeTaskRegister(url_server!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        if let result = String(data: data!, encoding: .utf8) {
                            if let count = Int(result) {
                                DispatchQueue.main.async {
                                    //註冊成功時返回登入頁面
                                    if count != 0 {
                                        //Alert及跳轉頁面設定
                                        let controller = UIAlertController(title: "註冊", message: "註冊成功！", preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "確認", style: .default) { (_) in
                                            let NextPage
                                                = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                                            NextPage.modalPresentationStyle = .fullScreen
                                            self.present(NextPage, animated: true, completion: nil)
                                        }
                                        
                                        controller.addAction(okAction)
                                        
                                        self.present(controller, animated: true, completion: nil)
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
    //隱藏小鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
