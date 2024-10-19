//
//  LoginController.swift
//  PetZone
//
//  Created by user264582 on 10/17/24.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(
            red: 1, green: 0.98, blue: 0.98, alpha: 1)

        let petSymbolImageView = UIImageView(image: UIImage(named: "LoginPet"))
        //        logoImageView.contentMode = .scaleAspectFit
        petSymbolImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(petSymbolImageView)

        // Input fields
        let emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor =
            UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0).cgColor
        emailTextField.layer.cornerRadius = 8.0

        emailTextField.translatesAutoresizingMaskIntoConstraints = false

        let passwordTextField = UITextField()
        passwordTextField.placeholder = "Senha"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor =
            UIColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0).cgColor  // Azul céu
        passwordTextField.layer.cornerRadius = 8.0
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false

        // Login button
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("Entrar", for: .normal)
        loginButton.backgroundColor = UIColor(
            red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0)
        loginButton.setTitleColor(.white, for: .normal)

        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(
            self, action: #selector(onLogin), for: .touchUpInside)
        loginButton.layer.cornerRadius = 12.0
        
        let registerButton = UIButton(type: .system)
        registerButton.setTitle("Cadastre-se", for: .normal)
        
        registerButton.setTitleColor(UIColor(
            red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0), for: .normal)

        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(
            self, action: #selector(navToRegisterView), for: .touchUpInside)
        registerButton.layer.cornerRadius = 12.0
        
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)

        NSLayoutConstraint.activate([
            petSymbolImageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            petSymbolImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            petSymbolImageView.heightAnchor.constraint(equalToConstant: 250),
            petSymbolImageView.widthAnchor.constraint(equalToConstant: 250),

            // Email TextField
            emailTextField.topAnchor.constraint(
                equalTo: petSymbolImageView.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),

            // Password TextField
            passwordTextField.topAnchor.constraint(
                equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(
                equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(
                equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),

            // Login Button
            loginButton.topAnchor.constraint(
                equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.widthAnchor.constraint(equalToConstant: 150),
            
            registerButton.topAnchor.constraint(
                equalTo: loginButton.bottomAnchor, constant: 30),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            registerButton.widthAnchor.constraint(equalToConstant: 150),
        ])

    }

    @objc func onLogin() {
        let homeViewController = HomeViewController()
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    @objc func navToRegisterView() {
        let registerViewController = RegisterViewController()
        navigationController?.pushViewController(registerViewController, animated: true)
    }

}
