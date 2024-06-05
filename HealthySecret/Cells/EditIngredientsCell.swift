//
//  exerciseCell.swift
//  HealthySecret
//
//  Created by 양승완 on 2024/01/31.
//

import Foundation
import UIKit
import SnapKit

class EditIngredientsCell : UITableViewCell {
    let name = UILabel()
    let gram = UILabel()
    let kcal = UILabel()
    let deleteButton = UIButton()
    
    required override init( style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )

        self.backgroundColor = .clear
        layoutToEdit()

    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutToEdit(){
       

        
        self.contentView.addSubview(self.name)
        self.contentView.addSubview(self.gram)
        self.contentView.addSubview(self.kcal)
        self.contentView.addSubview(self.deleteButton)
        
        self.gram.font = .systemFont(ofSize: 18)
        self.gram.textColor = .lightGray
        
        self.kcal.font = .systemFont(ofSize: 24)
        
        self.name.font = .systemFont(ofSize: 22)
        
        self.deleteButton.setImage(UIImage(systemName: "xmark") , for: .normal)
        self.deleteButton.tintColor = .black
        
        
        
        self.gram.snp.makeConstraints{
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
        self.kcal.snp.makeConstraints{
            $0.trailing.equalTo(self.deleteButton).inset(30)
            $0.centerY.equalTo(self)
        }
 

    }
    
    
  
    
    
    
    
}
