//
//  ViewController.swift
//  MovieProject
//
//  Created by 양승완 on 2023/10/04.
//

import UIKit

class DetailModalVC : UIViewController {
    

    
    let dic : [String:Any]
    
    init(dic : [String:Any]) {
        self.dic = dic
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        //super.init(coder: coder) 이것도 됨
    }
    

    
    let textLabels = [UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel()]
    var contentLabels = [UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel()]
    
    
    lazy var textStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: textLabels)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
      //  stackView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        
        
        
        return stackView
        
        
    }()
        
    lazy var contentStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: contentLabels)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
      //  stackView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        
        
        
        return stackView
        
        
    }()
    
    let topLabel : UILabel = {
       let label = UILabel()
        
        label.text = "영양정보"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 22)
        return label
        
    }()
    
    
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
    
        if let sheet = sheetPresentationController {
                sheet.detents = [.large()]
            }
        
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
    
  
    
   
    @objc
    func pop(_ sender : UIButton ){
        
        self.dismiss(animated: true)
        
    }

    func setView(){
        self.backButton.addTarget(self, action : #selector(pop) , for: .touchUpInside)
        
        let labelsText = ["총 열량" , "탄수화물" , "   -당류" , "단백질" , "지방" ,"   -포화지방" , "   -트랜스지방",  "나트륨" , "콜레스테롤"  ]
        let textColors : [UIColor] = [ .black , .black , .lightGray , .black , .black , .lightGray , .lightGray , .black , .black   ]
        for i in 0..<textLabels.count {
            textLabels[i].text = labelsText[i]
            textLabels[i].font = UIFont.systemFont(ofSize: 16)
            textLabels[i].textColor = textColors[i]
            
            contentLabels[i].font = UIFont.boldSystemFont(ofSize: 16)
            contentLabels[i].textColor = textColors[i]
            contentLabels[i].textAlignment = .right

            if(i==0){
                contentLabels[i].font = UIFont.boldSystemFont(ofSize: 22)

            }
            
            
            
            
        }
  
        
        
        
        
        contentLabels[0].text = String(describing: self.dic["kcal"] ?? "-") + " kcal"
        contentLabels[1].text = String(describing: self.dic["carbohydrates"] ?? "-") + " g"
        contentLabels[3].text = String(describing: self.dic["protein"] ?? "-") + " g"
        contentLabels[4].text = String(describing: self.dic["province"] ?? "-") + " g"
        contentLabels[8].text = String(describing: self.dic["cholesterol"] ?? "-") + " mg"
        contentLabels[5].text = String(describing: self.dic["fattyAcid"] ?? "-") + " mg"
        contentLabels[2].text = String(describing: self.dic["sugars"] ?? "-") + " mg"
        contentLabels[6].text = String(describing: self.dic["transFat"] ?? "-") + " mg"
        contentLabels[7].text = String(describing: self.dic["sodium"] ?? "-") + " mg"
        
        

        
        self.view.addSubview(self.textStackView)
        self.view.addSubview(self.contentStackView)
        self.view.addSubview(self.topLabel)
        self.view.addSubview(self.backButton)
    
    
        
        
        NSLayoutConstraint.activate([
            
            self.topLabel.topAnchor.constraint(equalTo: self.view.topAnchor , constant: 30),
            self.topLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor , constant: 25),
            self.topLabel.heightAnchor.constraint(equalToConstant: 20),
            
            
            self.backButton.topAnchor.constraint(equalTo: self.topLabel.topAnchor),
            self.backButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor , constant:  -25),
            self.backButton.heightAnchor.constraint(equalToConstant: 20),
            self.backButton.widthAnchor.constraint(equalToConstant: 22),
            
            
            self.textStackView.topAnchor.constraint(equalTo: self.topLabel.bottomAnchor , constant: 30),
            self.textStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor , constant: 0),
            self.textStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor , constant: 20),
            self.textStackView.widthAnchor.constraint(equalToConstant: (self.view.frame.width/2 - 20)),
            
            
            self.contentStackView.topAnchor.constraint(equalTo: self.topLabel.bottomAnchor , constant: 30),
            self.contentStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor , constant: 0),
            self.contentStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor , constant: -20),
            self.contentStackView.widthAnchor.constraint(equalToConstant: (self.view.frame.width/2 - 20)),

            
            
            
        ])
        
        setLines()
    }
    
    

    func setLines(){
        
        for i in 0..<textLabels.count{
            if( i == 0 || i == 2 || i == 3 || i == 6 || i == 7){
                
                let line = UIView()
                self.view.addSubview(line)
                
                line.backgroundColor = .lightGray
                line.heightAnchor.constraint(equalToConstant: 1).isActive = true
                line.leadingAnchor.constraint(equalTo: self.textStackView.leadingAnchor).isActive = true
                line.trailingAnchor.constraint(equalTo: self.contentStackView.trailingAnchor).isActive = true
                line.bottomAnchor.constraint(equalTo: self.contentLabels[i].bottomAnchor).isActive = true
                
                
                line.translatesAutoresizingMaskIntoConstraints = false
            }
        }
    }

}



