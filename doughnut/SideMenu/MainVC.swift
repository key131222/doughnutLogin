


import UIKit

class MainVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
         
    @IBAction func logout(_ sender: Any) {
        let changePage
                       = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                   changePage.modalPresentationStyle = .fullScreen
                   self.present(changePage, animated: true, completion: nil)
    }
}

