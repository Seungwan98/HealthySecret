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
        label.text = "라이센스 약관 동의"
        label.font = .systemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let thirdButton : UIButton = {
       let button = UIButton()
        button.setImage( UIImage(named: "arrow.png") , for:  .normal )
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
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
    
    @objc 
    func licenseTapped(_ sender : UIButton){
        
        
        self.coordinator?.pushLicenseVC()
        
        pop(sender)

    }
    
   
    func setView(){
        var idx = 0
       
      
        
           
        
        
        self.view.addSubview(bottomView)
        self.view.addSubview(topLabel)
        self.view.addSubview(firstLabel)
        self.view.addSubview(secondLabel)
        self.view.addSubview(thirdLabel)

        self.bottomView.addSubview(nextButton)
        self.view.addSubview(thirdButton)
        
        

        
    
        self.nextButton.addTarget( self , action :#selector(didPressedNext), for: .touchUpInside)
        
        
        self.backButton.addTarget(self, action : #selector(pop) , for: .touchUpInside)
        
        self.thirdButton.addTarget(self, action: #selector(licenseTapped), for: .touchUpInside)

        
    
    
        
        
        NSLayoutConstraint.activate([
            
           
            bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 100),
            

            topLabel.leadingAnchor.constraint(equalTo: self.bottomView.leadingAnchor , constant: 20),
            topLabel.trailingAnchor.constraint(equalTo: self.bottomView.trailingAnchor , constant: -20),
            topLabel.topAnchor.constraint(equalTo: self.view.topAnchor , constant: 20),
            
            
            firstLabel.leadingAnchor.constraint(equalTo: self.bottomView.leadingAnchor , constant: 50),
            firstLabel.topAnchor.constraint(equalTo: self.topLabel.bottomAnchor , constant: 30),
                
            secondLabel.leadingAnchor.constraint(equalTo: self.bottomView.leadingAnchor , constant: 50),
            secondLabel.topAnchor.constraint(equalTo: self.firstLabel.bottomAnchor , constant: 20),
                
            thirdLabel.leadingAnchor.constraint(equalTo: self.bottomView.leadingAnchor , constant: 50),
            thirdLabel.topAnchor.constraint(equalTo: self.secondLabel.bottomAnchor , constant: 20),  
            
            
            thirdButton.leadingAnchor.constraint(equalTo: self.thirdLabel.trailingAnchor , constant: 4 ),
            thirdButton.centerYAnchor.constraint(equalTo: self.thirdLabel.centerYAnchor ) ,
            thirdButton.widthAnchor.constraint(equalToConstant: 16 ) ,
            thirdButton.heightAnchor.constraint(equalToConstant: 16) ,
            
            
           
            
            

            
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
            btn.leadingAnchor.constraint(equalTo: self.bottomView.leadingAnchor , constant: 20 ).isActive = true
           
            
            idx += 1
        })
        
    }
    
    


}





class LicenseVC : UIViewController{
    
    var coordinator : LoginCoordinator?

    
    override func viewDidLoad() {
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.backgroundColor = .clear
    
        

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.coordinator?.presentModal()
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    func setUI() {
        
        self.view.backgroundColor = .white
        
        let label = UILabel()
        label.sizeToFit()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "최종 사용자 사용권 계약 (EULA)\n\n1. 소개 \n헬시크릿에 오신 것을 환영합니다. 본 애플리케이션을 사용함으로써 귀하는 다음 약관에 동의하게 됩니다. 주의 깊게 읽어주시기 바랍니다. \n\n2. 약관 수락 \n 헬시크릿을 접근하고 사용하는 것으로 귀하는 본 약관에 동의하게 됩니다. \n\n3. 사용자의 의무 및 책임 \n3.1 귀하는 본 애플리케이션을 사용함에 있어 다음과 같은 행위를 하지 않을 것에 동의합니다:\n *불쾌한 콘텐츠를 게시하거나 전송하는 행위 \n *다른 사용자에게 욕설, 괴롭힘, 협박 또는 악의적인    \n   행위를 하는 행위 \n *저작권, 상표권 또는 기타 지적 재산권을 침해하는 행위 \n3.2 본 애플리케이션은 위와 같은 행위에 대해 무관용 정책을 유지합니다. 귀하가 이러한 행위를 할 경우, 사전 통보 없이 계정이 정지되거나 종료될 수 있습니다. \n\n4. 콘텐츠 모니터링 및 보고 \n4.1 헬시크릿은 사용자 콘텐츠를 모니터링할 권리를 보유하며, 필요 시 부적절한 콘텐츠를 삭제할 수 있습니다. \n4.2 사용자는 불쾌한 콘텐츠나 악의적인 사용자를 발견할 경우 이를 즉시 헬시크릿에 보고할 수 있습니다. \n\n5. 계약 종료 \n헬시크릿은 본 약관의 위반이 발생할 경우, 사전 통보 없이 귀하의 계정을 종료할 수 있는 권리를 가집니다. \n\n6. 문의 \n본 약관에 대한 문의는( sinna3210@gmail.com )로 연락주시기 바랍니다."
        
        self.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor ,constant: 10 ),
            label.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor , constant: -10 ),
            label.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor ),

                                    
        ])
        
        
      
        
        
        
    }
}

