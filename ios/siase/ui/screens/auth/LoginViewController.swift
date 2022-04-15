//
//  ViewController.swift
//  siase
//
//  Created by Fernando Maldonado on 26/02/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let viewModel:LoginViewModel = DIContainer.shared.resolve(type: LoginViewModel.self)!
    
    private let stackView:LoginStackView = {
        let view = LoginStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let label:UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Iniciar Sesión"
        view.textAlignment = .center
        view.font = view.font.withSize(28)
        return view
    }()
    
    let loadingSpinnerView : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupViews()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.bindStatus = { status in
            self.changeStatus(status: self.viewModel.status)
        }
        
        viewModel.bindNeedsSelection = { selection in
            if(selection == nil){
                return
            }
            
            if(selection!){
                self.navigate(screen: MainCareerSelectionController())
            }else{
                self.navigate(screen: MainViewController())
            }
        }
        
        viewModel.checkSession()

    }
    
    private func changeStatus(status:Status){
        if(status == Status.Completed){
            viewModel.checkIfNeedsSelection()
            return
        }
        
        stackView.isHidden = status != Status.Loaded
        label.isHidden = status != Status.Loaded
        loadingSpinnerView.isHidden = status != Status.Loading
        
        if(status == Status.Loading){
            loadingSpinnerView.startAnimating()
        }
       else{
            loadingSpinnerView.stopAnimating()
        }

    }
    
    
    
    private func setupViews(){
        view.addSubview(stackView)
        view.addSubview(label)
        view.addSubview(loadingSpinnerView)

        view.layoutMargins = UIEdgeInsets.init(top: 50, left:10,bottom: 10,right: 10);
        
        stackView.setLoginClickListener {
            let username = self.stackView.getUsername()
            let password = self.stackView.getPassword()
            
            if(username == nil ||
               password == nil ||
               username!.isEmpty ||
               password!.isEmpty
            ) {
                return
            }
                
            self.viewModel.login(username: username!, password: password!)
        }

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor,constant: -50),
            label.bottomAnchor.constraint(equalTo: stackView.topAnchor,constant: -30),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 40),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -40),
            loadingSpinnerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            loadingSpinnerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)


        ])
        
            
        

    }


}

