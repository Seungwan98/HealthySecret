//
//  ProfileHeader.swift
//  HealthySecret
//
//  Created by 양승완 on 4/26/24.
//

import Foundation
import RxSwift
import UIKit


class ProfileHeaderView : UICollectionReusableView  {
    
    let disposeBag = DisposeBag()
    
    
    var appearEvent = PublishSubject<Bool>()
    
   var setBind = PublishSubject<Bool>()
   
    
    static let identifier = "CustomHeaderCollectionView"
    
    let profileImage : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 60
        view.layer.masksToBounds = true
        
        view.tintColor = .white
        
        
        return view
        
    }()
    
    let introduceLabel : UILabel = {
        let label = UILabel()
        label.text = "아직 소개글이 없어요."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.sizeToFit()
        label.font =  .boldSystemFont(ofSize: 18 )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
        
        
    }()
    
    var goalLabel : UILabel = {
        let label = UILabel()
        let imageAttachment = NSTextAttachment(image: UIImage(named: "arrow.png")!)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        let attributedString = NSMutableAttributedString(string: "")
        attributedString.append(NSAttributedString(string: "나의 목표 "))
        imageAttachment.bounds = CGRect(x: 0, y: 0.8, width: 10, height: 10)
        
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        
        label.attributedText = attributedString
        
        return label
        
        
    }()
    
    
    let rightLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "목표까지"
        label.font = .boldSystemFont(ofSize: 16)
        
        return label
        
        
    }()
    
    let gramLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        label.text = "80 kg"
        label.textColor = .systemBlue
        return label
        
        
    }()
    
    
    
    var nowWeight = UILabel()
    var calorieLabel = UILabel()
    var goalWeight = UILabel()
    let informLabel1 = UILabel()
    let informLabel2 = UILabel()
    let informLabel3 = UILabel()
    lazy var informLabelArr = [informLabel1 , informLabel2 , informLabel3]
    lazy var informDataArr = [nowWeight , calorieLabel , goalWeight]
    lazy var informationView : UIView = {
        let view = UIView()
        
        let stackView = UIStackView(arrangedSubviews: informLabelArr )
        
        view.addSubview(stackView)
        
        
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor ,constant: 50).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor ,constant: -50).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor , constant:  -15).isActive = true
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.distribution = .equalCentering
        
        
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        return view
        
    }()
    
    
    
    
    
    override init(frame: CGRect ) {
        super.init(frame: frame)
        setUI()

        print("headerInit")
    }
    
    required init?(coder: NSCoder) {
        
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
  
    
    
    
    
    private func setUI() {
   
        
        self.addSubview(informationView)
        self.addSubview(profileImage)
        self.addSubview(introduceLabel)
        self.addSubview(goalLabel)
        self.addSubview(rightLabel)
        self.addSubview(gramLabel)
        
        
  
        
        NSLayoutConstraint.activate([
            
            
            profileImage.widthAnchor.constraint(equalToConstant: 120),
            profileImage.heightAnchor.constraint(equalToConstant: 120),
            profileImage.topAnchor.constraint(equalTo: self.topAnchor , constant: 40 ),
            profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 40 ),
            
            
            introduceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 20 ),
            introduceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: -20 ),
            introduceLabel.topAnchor.constraint(equalTo: self.profileImage.bottomAnchor , constant: 5 ),
           // introduceLabel.heightAnchor.constraint(equalToConstant: 60 ),
            
            
            goalLabel.leadingAnchor.constraint(equalTo: informationView.leadingAnchor),
            goalLabel.topAnchor.constraint(equalTo: introduceLabel.bottomAnchor , constant: 10),
            
            
            gramLabel.trailingAnchor.constraint(equalTo: informationView.trailingAnchor ),
            gramLabel.centerYAnchor.constraint(equalTo: goalLabel.centerYAnchor ),
            
            
            rightLabel.trailingAnchor.constraint(equalTo: gramLabel.leadingAnchor , constant: -5),
            rightLabel.centerYAnchor.constraint(equalTo: goalLabel.centerYAnchor ),

            
            informationView.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 20),
            informationView.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: -20),
            informationView.topAnchor.constraint(equalTo: goalLabel.bottomAnchor , constant: 5),
            informationView.bottomAnchor.constraint(equalTo: self.bottomAnchor , constant: 5),
            informationView.heightAnchor.constraint(equalToConstant: 120),
            
  
        ])
        
        let text = ["현재 체중" , "칼로리" , "목표 체중"]
        for i in 0..<3{
            informLabelArr[i].text = text[i]
            informLabelArr[i].textColor = .lightGray.withAlphaComponent(0.8)
            informLabelArr[i].font = .boldSystemFont(ofSize: 16)
            
            
            self.addSubview(informDataArr[i])
            informDataArr[i].translatesAutoresizingMaskIntoConstraints = false
            informDataArr[i].font = .boldSystemFont(ofSize: 16)
            informDataArr[i].textColor = .black
            
            
            informDataArr[i].centerXAnchor.constraint(equalTo: informLabelArr[i].centerXAnchor).isActive = true
            
            
            informDataArr[i].centerYAnchor.constraint(equalTo: informationView.centerYAnchor , constant: 15).isActive = true
            
            
        }
        
    }
    
    
    
    
    
}

