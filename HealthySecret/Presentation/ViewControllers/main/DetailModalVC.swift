//
//  ViewController.swift
//  MovieProject
//
//  Created by 양승완 on 2023/10/04.
//

import UIKit
import SnapKit
class DetailModalVC : UIViewController {
    

    
    private let models : IngredientsModel
    
    init(models :IngredientsModel) {
        self.models = models
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
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
      //  stackView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        
        
        
        return stackView
        
        
    }()
        
    lazy var contentStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: contentLabels)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
      //  stackView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        
        
        
        return stackView
        
        
    }()
    
    let topLabel : UILabel = {
       let label = UILabel()
        
        label.text = "영양정보"
        label.font = .boldSystemFont(ofSize: 22)
        return label
        
    }()
    
    
    let backButton : UIButton = {
       let button  = UIButton()
        
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill

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
  
        
        
        
        
        contentLabels[0].text = String(describing: models.calorie) + " kcal"
        contentLabels[1].text = String(describing: models.carbohydrates) + " g"
        contentLabels[3].text = String(describing: models.protein) + " g"
        contentLabels[4].text = String(describing: models.province) + " g"
        contentLabels[8].text = String(describing: models.cholesterol) + " mg"
        contentLabels[5].text = String(describing: models.fattyAcid) + " mg"
        contentLabels[2].text = String(describing: models.sugars) + " mg"
        contentLabels[6].text = String(describing: models.transFat) + " mg"
        contentLabels[7].text = String(describing: models.sodium) + " mg"
        
        

        
        self.view.addSubview(self.textStackView)
        self.view.addSubview(self.contentStackView)
        self.view.addSubview(self.topLabel)
        self.view.addSubview(self.backButton)
    
    
        self.topLabel.snp.makeConstraints{
            $0.top.equalTo(self.view).inset(30)
            $0.leading.equalTo(self.view).inset(25)
            $0.height.equalTo(20)
        }
        self.backButton.snp.makeConstraints{
            $0.top.equalTo(self.topLabel)
            $0.trailing.equalTo(self.view).inset(25)
            $0.height.equalTo(20)
            $0.width.equalTo(22)
        }
        self.textStackView.snp.makeConstraints{
            $0.top.equalTo(self.topLabel.snp.bottom).offset(30)
            $0.bottom.equalTo(self.view)
            $0.leading.equalTo(self.view).inset(20)
            $0.width.equalTo(self.view.frame.width/2 - 20)
        }
        self.contentStackView.snp.makeConstraints{
            $0.top.equalTo(self.topLabel.snp.bottom).offset(30)
            $0.bottom.equalTo(self.view)
            $0.trailing.equalTo(self.view).inset(20)
            $0.width.equalTo(self.view.frame.width/2 - 20)
        }
     
        
        setLines()
    }
    
    

    func setLines(){
        
        for i in 0..<textLabels.count{
            if( i == 0 || i == 2 || i == 3 || i == 6 || i == 7){
                
                let line = UIView()
                self.view.addSubview(line)
                
                line.snp.makeConstraints{
                    $0.height.equalTo(1)
                    $0.leading.equalTo(self.textStackView)
                    $0.trailing.equalTo(self.contentStackView)
                    $0.bottom.equalTo(self.contentLabels[i])
                }
                line.backgroundColor = .lightGray
       
                
                
            }
        }
    }

}



