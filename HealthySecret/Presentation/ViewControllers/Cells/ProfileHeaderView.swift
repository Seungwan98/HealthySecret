//
//  ProfileHeader.swift
//  HealthySecret
//
//  Created by 양승완 on 4/26/24.
//

import Foundation
import RxSwift
import UIKit
import SnapKit


class ProfileHeaderView: UICollectionViewCell {
    
    let disposeBag = DisposeBag()
    
    static let identifier = "profileHeaderView"
    
    var appearEvent = PublishSubject<Bool>()
    
    var setBind = PublishSubject<Bool>()
    
    
    let feedInformValLabels = [UILabel(), UILabel(), UILabel()]
    
    let feedInformTextLabels = [UILabel(), UILabel(), UILabel()]
    
    let feedInformTexts = ["피드", "팔로워", "팔로잉"]
    
    lazy var informationStackView = {
        let stackview = UIStackView(arrangedSubviews: feedInformValLabels)
        stackview.axis = .horizontal
        stackview.distribution = .fillEqually
        stackview.alignment = .center
        
        
        return stackview
    }()
    
    
    
    let profileImage: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 60
        view.layer.masksToBounds = true
        
        view.tintColor = .white
        
        
        return view
        
    }()
    
    let introduceLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 소개글이 없어요."
        label.textAlignment = .left
        label.numberOfLines = 0
        label.sizeToFit()
        label.font =  .systemFont(ofSize: 16 )
        return label
        
        
        
    }()
    
    var goalLabel: UILabel = {
        let label = UILabel()
        let imageAttachment = NSTextAttachment(image: UIImage(named: "arrow.png")!)
        label.font = .boldSystemFont(ofSize: 16)
        let attributedString = NSMutableAttributedString(string: "")
        attributedString.append(NSAttributedString(string: "나의 목표 "))
        imageAttachment.bounds = CGRect(x: 0, y: 0.8, width: 10, height: 10)
        
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        
        label.attributedText = attributedString
        
        return label
        
        
    }()
    
    
    let rightLabel: UILabel = {
        let label = UILabel()
        label.text = "목표까지"
        label.font = .boldSystemFont(ofSize: 16)
        
        return label
        
        
    }()
    
    let gramLabel: UILabel = {
        let label = UILabel()
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
    lazy var informLabelArr = [informLabel1, informLabel2, informLabel3]
    lazy var informDataArr = [nowWeight, calorieLabel, goalWeight]
    public lazy var informationView: UIView = {
        let view = UIView()
        
        let stackView = UIStackView(arrangedSubviews: informLabelArr )
        
        view.addSubview(stackView)
        
        
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view).inset(50)
            $0.height.equalTo(20)
            $0.centerY.equalTo(view).offset(-15)
        }
        
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.distribution = .equalCentering
        
        
        view.layer.cornerRadius = 20
        
        
        
        return view
        
    }()
    
    
    
    let topImage = UIImageView(image: UIImage(named: "camera.png"))
    
    override init(frame: CGRect ) {
        super.init(frame: frame)
        setUI()
        setStackViews()
        print("headerInit")
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    
    
    private func setStackViews() {
        var idx = 0
        
        feedInformValLabels.forEach {
            let value = $0
            value.tag = idx
            value.textAlignment = .center
            value.text = "0"
            value.font = .boldSystemFont(ofSize: 24)
            
            
            
            
            
            self.addSubview(feedInformTextLabels[idx])
            
            feedInformTextLabels[idx].text = feedInformTexts[idx]
            feedInformTextLabels[idx].font = .systemFont(ofSize: 12)
            
            feedInformTextLabels[idx].snp.makeConstraints {
                $0.centerX.equalTo(value)
                $0.bottom.equalTo(value.snp.top).offset(-5)
            }
            
            
            
            
            idx += 1
            
            
        }
        
        
        
    }
    
    
    
    private func setUI() {
        
        
        self.addSubview(informationView)
        self.addSubview(profileImage)
        self.addSubview(informationStackView)
        self.addSubview(introduceLabel)
        self.addSubview(goalLabel)
        self.addSubview(rightLabel)
        self.addSubview(gramLabel)
        self.addSubview(topImage)
        
        
        topImage.isHidden = true
        
        
        self.profileImage.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.top.leading.equalTo(self).inset(20)
        }
        self.introduceLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(self).inset(20)
            $0.top.equalTo(self.profileImage.snp.bottom).offset(10)
            $0.bottom.equalTo(self.goalLabel.snp.top).offset(-10)
        }
        self.goalLabel.snp.makeConstraints {
            $0.leading.equalTo(informationView)
            $0.bottom.equalTo(informationView.snp.top).offset(-10)
        }
        self.gramLabel.snp.makeConstraints {
            $0.trailing.equalTo(informationView)
            $0.centerY.equalTo(goalLabel)
        }
        self.rightLabel.snp.makeConstraints {
            $0.trailing.equalTo(gramLabel.snp.leading).offset(-5)
            $0.centerY.equalTo(goalLabel)
        }
        self.informationView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self).inset(20)
            $0.height.equalTo(120)
            $0.bottom.equalTo(self).inset(20)
        }
        self.topImage.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.trailing.bottom.equalTo(self.profileImage)
        }
        self.informationStackView.snp.makeConstraints {
            $0.centerY.equalTo(profileImage).offset(4)
            $0.leading.equalTo(profileImage.snp.trailing).offset(30)
            $0.trailing.equalTo(self).inset(30)
            $0.height.equalTo(40)
        }
        
        
        
        
        let text = ["현재 체중", "칼로리", "목표 체중"]
        for i in 0..<3 {
            informLabelArr[i].text = text[i]
            informLabelArr[i].textColor = .lightGray.withAlphaComponent(0.8)
            informLabelArr[i].font = .boldSystemFont(ofSize: 16)
            
            informDataArr[i].font = .boldSystemFont(ofSize: 16)
            informDataArr[i].textColor = .black
            
            self.addSubview(informDataArr[i])
            
            
            
            informDataArr[i].snp.makeConstraints {
                $0.centerX.equalTo(informLabelArr[i])
                $0.centerY.equalTo(informationView).offset(15)
                
            }
            
            
            
        }
        
    }
    
    
    
    
    
}
