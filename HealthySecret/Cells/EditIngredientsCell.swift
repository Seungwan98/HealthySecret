//
//  exerciseCell.swift
//  HealthySecret
//
//  Created by 양승완 on 2024/01/31.
//

import Foundation
import UIKit

class EditIngredientsCell : UITableViewCell {
    let name = UILabel()
    let gram = UILabel()
    let kcal = UILabel()
    let deleteButton = UIButton()
    
    required override init( style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )
        self.name.translatesAutoresizingMaskIntoConstraints = false
        self.gram.translatesAutoresizingMaskIntoConstraints = false
        self.kcal.translatesAutoresizingMaskIntoConstraints = false
        self.deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        
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
        
        self.gram.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 20).isActive = true
        self.gram.centerYAnchor.constraint(equalTo: self.centerYAnchor , constant: 14).isActive = true
        
      
        
        self.name.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        self.name.centerYAnchor.constraint(equalTo: self.centerYAnchor , constant: -14).isActive = true
        
        self.deleteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: -20 ).isActive = true
        self.deleteButton.widthAnchor.constraint(equalToConstant: 20 ).isActive = true
        self.deleteButton.heightAnchor.constraint(equalToConstant: 20 ).isActive = true
        
        
        self.kcal.trailingAnchor.constraint(equalTo: self.deleteButton.trailingAnchor, constant: -30).isActive = true
        self.kcal.centerYAnchor.constraint(equalTo: self.centerYAnchor ).isActive = true

    }
    
    
  
    
    
    
    
}
