//
//  ViewController.swift
//  MovieProject
//
//  Created by 양승완 on 2023/10/04.
//

import UIKit
import RxSwift
class AssignModalVC : UIViewController {
    

    
    var coordinator : LoginCoordinator?
    
  
    
    let backButton : UIButton = {
       let button  = UIButton()
        
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.backgroundColor = .red
        
        return button
        
    }()
    
 
    
    let nextButton : UIButton = {
       let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("완료", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.isEnabled = false
        button.backgroundColor =  .lightGray
        
        return button
    }()
 
    let bottomView : UIView = {
        
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let topLabel : UILabel = {
        let label = UILabel()
        label.text = "약관동의"
        label.font = .boldSystemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
let firstLabel : UILabel = {
        let label = UILabel()
        label.text = "만 14세 이상입니다"
        label.font = .systemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
let secondLabel : UILabel = {
        let label = UILabel()
        label.text = "개인정보 수집 동의"
        label.font = .systemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let thirdLabel : UILabel = {
        let label = UILabel()
        label.text = "서비스 이용 동의"
        label.font = .systemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
  
    var checkBoxButtons =  [ UIButton() ,UIButton() ,UIButton()]
    lazy var labels : [UILabel] = [ firstLabel , secondLabel , thirdLabel ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
     
    }


    

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.view.layer.cornerRadius = 30

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    
  
    @objc func didPressedHeart(_ sender: UIButton) {
        
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            print(sender.isSelected)
            sender.setImage(UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)

        }else {
            sender.setImage(UIImage(systemName: "checkmark.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)

            
        }
        
        if( checkBoxButtons[0].isSelected && checkBoxButtons[1].isSelected && checkBoxButtons[2].isSelected ){
            
            self.nextButton.isEnabled = true
            self.nextButton.backgroundColor = .black
        }else{
            
            self.nextButton.isEnabled = false
            self.nextButton.backgroundColor = .lightGray
        }
        
        
    }
    
    
   
    @objc
    func pop(_ sender : UIButton ){
        
        self.dismiss(animated: true)
        
    }
    @objc
    func didPressedNext(_ sender : UIButton ){
        self.pop(sender)
        self.coordinator?.pushSignUpVC()
        
    }
    
   
    func setView(){
        var idx = 0
       
      
        
           
        
        
        self.view.addSubview(bottomView)
        self.view.addSubview(topLabel)
        self.view.addSubview(firstLabel)
        self.view.addSubview(secondLabel)
        self.view.addSubview(thirdLabel)

        self.bottomView.addSubview(nextButton)
        self.nextButton.addTarget( self , action :#selector(didPressedNext), for: .touchUpInside)
        
        
        self.backButton.addTarget(self, action : #selector(pop) , for: .touchUpInside)
        
       
        
    
    
        
        
        NSLayoutConstraint.activate([
            
           
            bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 100),
            

            topLabel.leadingAnchor.constraint(equalTo: self.bottomView.leadingAnchor , constant: 20),
            topLabel.trailingAnchor.constraint(equalTo: self.bottomView.trailingAnchor , constant: -20),
            topLabel.topAnchor.constraint(equalTo: self.view.topAnchor , constant: 20),
            
            
            firstLabel.leadingAnchor.constraint(equalTo: self.bottomView.leadingAnchor , constant: 20),
            firstLabel.topAnchor.constraint(equalTo: self.topLabel.bottomAnchor , constant: 30),
                
            secondLabel.leadingAnchor.constraint(equalTo: self.bottomView.leadingAnchor , constant: 20),
            secondLabel.topAnchor.constraint(equalTo: self.firstLabel.bottomAnchor , constant: 20),
                
            thirdLabel.leadingAnchor.constraint(equalTo: self.bottomView.leadingAnchor , constant: 20),
            thirdLabel.topAnchor.constraint(equalTo: self.secondLabel.bottomAnchor , constant: 20),
            
            
           
            
            

            
            nextButton.leadingAnchor.constraint(equalTo:bottomView.leadingAnchor , constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20 ),
            nextButton.heightAnchor.constraint(equalToConstant: 60),
            nextButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor , constant: -10 ),
            
           
      
            
            
            
            
            
        ])
        
        checkBoxButtons.forEach({ btn in
            
            btn.setImage(UIImage(systemName: "checkmark.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(btn)

            btn.addTarget(self, action: #selector(self.didPressedHeart), for: .touchUpInside)
            
            btn.centerYAnchor.constraint(equalTo: labels[idx].centerYAnchor ).isActive = true
            btn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor , constant: -20 ).isActive = true
           
            
            idx += 1
        })
        
    }
    
    


}



