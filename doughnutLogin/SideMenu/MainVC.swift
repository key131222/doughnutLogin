import UIKit
//登入成功頁面設定
class MainVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let controller = UIAlertController(title: "登入成功！", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        let changePage
            = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        changePage.modalPresentationStyle = .fullScreen
        self.present(changePage, animated: true, completion: nil)
    }
}
