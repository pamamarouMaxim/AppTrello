//
//  ViewController.swift
//  TrelloProgect
//
//  Created by Maxim Panamarou on 7/24/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.

import UIKit
import CoreData
import Alamofire

class LoginViewController: UIViewController {
  
  @IBOutlet private weak var mailTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var loginButton: UIButton!
  
  private static let storyboardName = "Boards"
  private static let nextViewController = "AfterNavigationController"
  private var activityIndicatorView: UIActivityIndicatorView?
  private var viewModel = LoginViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.isNavigationBarHidden = false
    self.loadSettingsOfButton()
    self.loadSettingsToTextFields()
  }

  @IBAction private func loginButtonTapped(_ sender: UIButton) {
    if let mail = mailTextField?.text, let password = passwordTextField?.text {
      self.activityIndicatorWithAction(.show)
      viewModel.authorizeUserWithEmail(mail, password: password) { [weak self](error) in
        if let error = error {
          self?.activityIndicatorWithAction(.remove)
          let alert = UIAlertController.alertWithError(error)
          self?.present(alert, animated: true) {}
        } else {
          let navigationController = UIStoryboard.init(name: LoginViewController.storyboardName,
              bundle: Bundle.main).instantiateViewController(withIdentifier: LoginViewController.nextViewController) as? UINavigationController
          guard let boardsNavigation = navigationController else {return}
          self?.passwordTextField.text = ""
          self?.mailTextField.text = ""
          self?.viewModel.removeLogin()
          self?.activityIndicatorWithAction(.remove)
          self?.present(boardsNavigation, animated: true, completion: { })
        }
      }
    }
  }

  private func loadSettingsToTextFields() {
    mailTextField.becomeFirstResponder()
  }

  private func loadSettingsOfButton() {
   loginButton.layer.cornerRadius = 5
   loginButton.layer.borderWidth = 1
   loginButton.layer.borderColor = UIColor.black.cgColor
  }
}

extension LoginViewController: UITextFieldDelegate{
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case mailTextField    : passwordTextField.becomeFirstResponder()
    case passwordTextField: passwordTextField.resignFirstResponder()
    default: break
    }
    return true
  }
}

extension LoginViewController {
  
  private enum ActivityIndicator {
    case show
    case remove
  }
    
  private func activityIndicatorWithAction(_ action: ActivityIndicator) {
    switch action {
    case .remove: activityIndicatorView?.removeFromSuperview()
                  loginButton.isHidden = false
    case .show  : let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
                  activityIndicator.activityIndicatorViewStyle = .gray
                  activityIndicator.center = loginButton.center
                  self.loginButton.isHidden = true
                  self.view.addSubview(activityIndicator)
                  activityIndicatorView = activityIndicator
                  activityIndicator.startAnimating()
    }
  }
}
