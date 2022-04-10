import UIKit

class LogInViewController: UIViewController {
    
    // MARK: - let/var
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logInLabel: UILabel = {
        let label = UILabel()
        label.text = "Log in"
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.layer.borderWidth = 3
        textField.layer.cornerRadius = 10
        textField.placeholder = "Username"
        textField.setLeftPaddingPoints(16)
        textField.setRightPaddingPoints(16)
        textField.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.layer.borderWidth = 3
        textField.layer.cornerRadius = 10
        textField.placeholder = "Password"
        textField.setLeftPaddingPoints(16)
        textField.setRightPaddingPoints(16)
        textField.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Log in", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(logInButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        let mutableString = NSMutableAttributedString(string: "Don’t have an account? Sign up.")
        mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.link, range: NSRange(location: 23, length: 8))
        button.setAttributedTitle(mutableString, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var mainStackView = UIStackView()
    
    // MARK: - lifecycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setUpDelegate()
        registerKeyboardNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpViews()
        setConstraints()
    }
    
    // MARK: - deinit
    deinit {
        removeKeyboardNotification()
    }
    
    // MARK: - IBActions
    @IBAction private func logInButtonPressed() {
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let user = Manager.shared.findUserDataBase(email: email)
        
        if user == nil {
            alert(title: "Can't find account", message: "We can't find your account. Try another username, or if you don't have an account, you can sign up.", button: "Try again")
        } else if user?.password == password {
            guard let activeUser = user else { return }
            Manager.shared.saveActiveUser(user: activeUser)
            
            let tabBarVC = UITabBarController()
            
            let firstVC = UINavigationController(rootViewController: PhotosViewController())
            firstVC.title = "Photos"
            
            let secondVC = UINavigationController(rootViewController: UsersViewController())
            secondVC.title = "Users"
            
            tabBarVC.setViewControllers([firstVC, secondVC], animated: false)
            
            guard let items = tabBarVC.tabBar.items else { return }
            
            let images = ["photo.fill.on.rectangle.fill", "person.crop.circle.fill"]
            
            for index in 0..<items.count {
                items[index].image = UIImage(systemName: images[index])
            }
            
            tabBarVC.modalPresentationStyle = .fullScreen
            
            self.present(tabBarVC, animated: true)
        } else {
            alert(title: "Incorrect password", message: "Try another password, or if you don't have an account, you can sign up.", button: "Try again")
        }
        
    }
    
    @IBAction private func signUpButtonPressed() {
        let signUpVC = SignUpViewController()
        signUpVC.modalPresentationStyle = .fullScreen
        self.present(signUpVC, animated: true)
    }
    
    @IBAction private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - flow funcs
    private func setUpViews() {
        title = "Log in"
        view.backgroundColor = .white
        
        mainStackView = UIStackView(arrangedSubviews: [logInLabel, emailTextField, passwordTextField, logInButton, signUpButton])
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        mainStackView.distribution = .fillEqually
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(mainStackView)
    }
    
    private func setUpDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
}

// MARK: - UTTextFieldDelegate
extension LogInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}

// MARK: - keyboard show/hide
extension LogInViewController {
    private func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction private func keyboardWillShow(notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardHeight = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        scrollView.contentOffset = (CGPoint(x: 0, y: keyboardHeight / 2))
    }
    
    @IBAction private func keyboardWillHide(notification: Notification) {
        scrollView.contentOffset = CGPoint.zero
    }
}

// MARK: - constraints
extension LogInViewController {
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            logInButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
}
