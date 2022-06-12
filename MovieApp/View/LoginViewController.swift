//
//  LoginViewController.swift
//  MovieApp
//
//  Created by Elif Yalçın on 12.06.2022.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController {
    
    private let appImage = UIImageView()
    private let appName = UILabel()
    private let loginTitleLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    private let orLabel = UILabel()
    private let loginViaWebsiteButton = UIButton()
    let signInConfig = GIDConfiguration(clientID: "84776359113-fgrdl5j5lkrj4ned9q8bd8gfm5klm16a.apps.googleusercontent.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        customizeViews()
    }
    
    func setViews() {
        view.addSubview(appImage)
        view.addSubview(appName)
        view.addSubview(loginTitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(orLabel)
        view.addSubview(loginViaWebsiteButton)
        
        appImage.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        appName.snp.makeConstraints { (make) in
            make.top.equalTo(appImage.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        loginTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(appName.snp.bottom).offset(120)
            make.centerX.equalToSuperview()
        }
        emailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(loginTitleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(35)
        }
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(35)
        }
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(35)
        }
        orLabel.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        loginViaWebsiteButton.snp.makeConstraints { (make) in
            make.top.equalTo(orLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(35)
        }
        
    }
    
    func customizeViews() {
        view.backgroundColor = AppConstants.loginBackgroundColor
        
        appImage.image = UIImage(named: "movie")
        
        appName.text = AppConstants.appName
        appName.font = .systemFont(ofSize: 20, weight: .bold)
        appName.textColor = .white
        
        loginTitleLabel.textColor = .white
        loginTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        loginTitleLabel.text = AppConstants.loginTitleText
        
        emailTextField.placeholder = AppConstants.emailPlaceholder
        emailTextField.backgroundColor = AppConstants.textFieldBackgroundColor
        emailTextField.layer.cornerRadius = 5
        emailTextField.autocapitalizationType = .none
        passwordTextField.placeholder = AppConstants.passwordPlaceholder
        passwordTextField.backgroundColor = AppConstants.textFieldBackgroundColor
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        
        loginButton.backgroundColor = AppConstants.buttonBackgroundColor
        loginButton.setTitle(AppConstants.loginButtonTitle, for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(loginWithEmail), for: .touchUpInside)
        
        loginViaWebsiteButton.backgroundColor = AppConstants.buttonBackgroundColor
        loginViaWebsiteButton.setTitle(AppConstants.loginWithGoogleTitle, for: .normal)
        loginViaWebsiteButton.setTitleColor(.white, for: .normal)
        loginViaWebsiteButton.layer.cornerRadius = 5
        loginViaWebsiteButton.addTarget(self, action: #selector(loginWithGoogle), for: .touchUpInside)
        
        orLabel.text = AppConstants.orText
        orLabel.font = .systemFont(ofSize: 20, weight: .bold)
        orLabel.textColor = .white
        
        navigationController?.navigationBar.isHidden = true
        
    }
    
    @objc func loginWithGoogle() {
        GIDSignIn.sharedInstance.signIn(
          with: signInConfig,
            presenting: self) { user, error in
            guard let signInUser = user else {
              return
            }
            let rootVC = TabBarViewController()
            rootVC.modalPresentationStyle = .fullScreen
            let navVC = UINavigationController(rootViewController: rootVC)
            self.present(navVC, animated: true)
          }
    }
    
    @objc func loginWithEmail() {
        
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            let alert = UIAlertController(title: "Error!", message: AppConstants.emptyMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                
            }))
            present(alert, animated: true)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in
            
            guard let strongSelf = self else {
                return
            }
            
            if let x = error {
                let err = x as NSError
                switch err.code {
                case AuthErrorCode.wrongPassword.rawValue:
                    let alert = UIAlertController(title: "Error!", message: AppConstants.wrongPasswordMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                        self!.emailTextField.text = ""
                        self!.passwordTextField.text = ""
                    }))
                    self!.present(alert, animated: true)
                case AuthErrorCode.userNotFound.rawValue:
                    strongSelf.showCreateAccount(email: email, password: password)
                default:
                    let alert = UIAlertController(title: "Error!", message: err.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                        self!.emailTextField.text = ""
                        self!.passwordTextField.text = ""
                    }))
                    self!.present(alert, animated: true)
                }
            } else {
                UserDefaults.standard.setValue(email, forKey: "userEmail")
                let rootVC = TabBarViewController()
                rootVC.modalPresentationStyle = .fullScreen
                let navVC = UINavigationController(rootViewController: rootVC)
                self!.present(navVC, animated: true)
            }
        })
    }
    
    func showCreateAccount(email: String, password: String) {
        let alert = UIAlertController(title: "Create Account", message: AppConstants.createAccountText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { result, error in
                if error != nil {
                    let alert = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                    }))
                    self.present(alert, animated: true)
                } else {
                    UserDefaults.standard.setValue(email, forKey: "userEmail")
                    let rootVC = TabBarViewController()
                    rootVC.modalPresentationStyle = .fullScreen
                    let navVC = UINavigationController(rootViewController: rootVC)
                    
                    self.present(navVC, animated: true)
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        }))
        present(alert, animated: true)
    }
}
