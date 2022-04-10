import UIKit

class UsersViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setView()
    }
    
    private func setView() {
        title = "Users"
        view.backgroundColor = .gray
    }
}
