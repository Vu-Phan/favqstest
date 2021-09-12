//
//  ViewController.swift
//  favqstest
//
//  Created by Vu Phan on 12/09/2021.
//

import UIKit

class LoginVC: UIViewController {
    // MARK: Xib
    @IBOutlet weak var formContentView: UIView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmButton: AppButton!
    
    
    // MARK: - View Controller
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkUserToken()
    }
    
    
    // MARK: - UI
    private func setupUI() {
        formContentView.pr_roundBackground(color: UIColor.app.main02, radius: 8)
        
        loginLabel.pr_setup(font: UIFont.app.body1, color: UIColor.app.text02)
        passwordLabel.pr_setup(font: UIFont.app.body1, color: UIColor.app.text02)
        passwordTextField.isSecureTextEntry = true
        
        loginLabel.text = "Login"
        passwordLabel.text = "Password"
        confirmButton.style1(text: "Continuer")
    }
    
    
    // MARK: - Data
    private func checkUserToken() {
        if let login = App.shared.isLoginSessionExist() {
            ServiceFavqs.shared.getUser(login: login, done: { user in
                if let user = user {
                    dump(user)
                    App.shared.user = user
                    self.showNext()
                } else {
                    App.shared.deleteSession()
                }
            })
        }
    }
    
    
    // MARK: - Navigation
    private func showNext() {
        let vcToShow = MainFavQuoteVC()
        self.navigationController?.pushViewController(vcToShow, animated: true)
    }
    
    
    // MARK: - Xib handlers
    @IBAction func confirmButtonHandler(_ sender: Any) {
        confirmButton.isEnabled = false
        
        if let login = loginTextField.text, let pwd = passwordTextField.text, !login.isEmpty && !pwd.isEmpty {
            ServiceFavqs.shared.getSession(login: login, pwd: pwd, done: { session in
                if let session = session {
                    App.shared.saveSession(session)
                    self.checkUserToken()
                }
                
                self.confirmButton.isEnabled = true
            })
        }
        
    }
}

