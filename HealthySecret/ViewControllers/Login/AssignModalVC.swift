//
//  ViewController.swift
//  MovieProject
//
//  Created by 양승완 on 2023/10/04.
//

import UIKit

class AssignModalVC : UIViewController {
    

    
 
    
  
    
    let backButton : UIButton = {
       let button  = UIButton()
        
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        
        return button
        
    }()
    
 
    
 
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }


    

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.view.layer.cornerRadius = 30

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    
  
    
   
    @objc
    func pop(_ sender : UIButton ){
        
        self.dismiss(animated: true)
        
    }

    func setView(){
        
        self.view.addSubview(backButton)
        
        self.backButton.addTarget(self, action : #selector(pop) , for: .touchUpInside)
        
       
  
    
    
        
        
        NSLayoutConstraint.activate([
            
           
            
            
            self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor , constant: 5),
            self.backButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor , constant:  -25),
            self.backButton.heightAnchor.constraint(equalToConstant: 20),
            self.backButton.widthAnchor.constraint(equalToConstant: 22),
            
            
           

            
            
            
        ])
        
    }
    
    


}



