//
//  exerciseCell.swift
//  HealthySecret
//
//  Created by 양승완 on 2024/01/31.
//

import Foundation
import UIKit
import SnapKit
class EditExerciseCell : UITableViewCell {
    let name = UILabel()
    let time = UILabel()
    let calorie = UILabel()
    let exerciseGram = UILabel()
    let deleteButton = UIButton()
    
    required override init( style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )
        self.backgroundColor = .clear

    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutToEdit(){
        
        //layoutToEdit
        //
        //
        
        self.contentView.addSubview(self.name)
        self.contentView.addSubview(self.time)
        self.contentView.addSubview(self.calorie)
        self.contentView.addSubview(self.exerciseGram)
        self.contentView.addSubview(self.deleteButton)
        
        self.time.font = .systemFont(ofSize: 18)
        self.time.textColor = .lightGray
        
        self.exerciseGram.font = .systemFont(ofSize: 24)
        self.exerciseGram.textAlignment = .right
        
        self.name.font = .systemFont(ofSize: 22)
        
        self.deleteButton.setImage(UIImage(systemName: "xmark") , for: .normal)
        self.deleteButton.tintColor = .black
        
        self.time.snp.makeConstraints{
            $0.leading.equalTo(self).inset(20)
            $0.centerY.equalTo(self).offset(14)
        }
        self.name.snp.makeConstraints{
            $0.leading.equalTo(self).inset(20)
            $0.centerY.equalTo(self).offset(-14)

        }
        self.deleteButton.snp.makeConstraints{
            $0.centerY.equalTo(self)
            $0.trailing.equalTo(self).inset(20)
            $0.width.height.equalTo(20)
        }
        self.exerciseGram.snp.makeConstraints{
            $0.trailing.equalTo(self.deleteButton).inset(30)
            $0.centerY.equalTo(self)
        }
        self.name.snp.makeConstraints{
            $0.trailing.equalTo(self.exerciseGram.snp.leading).offset(-10)
        }
   


    }
    
    
    func layoutToAdd() {
        
        
        self.name.font = .systemFont(ofSize: 18)
        self.contentView.addSubview(self.name)

        self.name.snp.makeConstraints{
            $0.leading.equalTo(self).inset(15)
            $0.centerY.equalTo(self)
        }
        

        
       
        
        
    }
    
    
    
    
}
