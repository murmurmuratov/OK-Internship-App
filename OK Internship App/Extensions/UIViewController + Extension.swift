import UIKit

extension UIViewController {
    
    func alert(title: String, message: String, button: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: button, style: .default)
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true)
    }
    
    func createCustomNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.gray
    }
}
