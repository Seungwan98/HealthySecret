//
//  exerciseCell.swift
//  HealthySecret
//
//  Created by 양승완 on 2024/01/31.
//

import Foundation
import UIKit

class ExerciseCell : UITableViewCell {
    let name = UILabel()
    let time = UILabel()
    let calorie = UILabel()
    let exerciseGram = UILabel()
    let deleteButton = UIButton()
    
    required override init( style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )
        self.name.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear

    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutToEdit(){
        
        
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
        
        self.time.translatesAutoresizingMaskIntoConstraints = false
        self.time.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 20).isActive = true
        self.time.centerYAnchor.constraint(equalTo: self.centerYAnchor , constant: 14).isActive = true
        
      
        
        self.name.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        self.name.centerYAnchor.constraint(equalTo: self.centerYAnchor , constant: -14).isActive = true
        
        self.deleteButton.translatesAutoresizingMaskIntoConstraints = false
        self.deleteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: -20 ).isActive = true
        self.deleteButton.widthAnchor.constraint(equalToConstant: 20 ).isActive = true
        self.deleteButton.heightAnchor.constraint(equalToConstant: 20 ).isActive = true
        
        
        self.exerciseGram.translatesAutoresizingMaskIntoConstraints = false
        self.exerciseGram.trailingAnchor.constraint(equalTo: self.deleteButton.trailingAnchor, constant: -30).isActive = true
        self.exerciseGram.centerYAnchor.constraint(equalTo: self.centerYAnchor ).isActive = true
        
        self.name.trailingAnchor.constraint(equalTo: self.exerciseGram.leadingAnchor  , constant: -10).isActive = true


    }
    
    
    func layoutToAdd() {
        
        
        self.name.font = .systemFont(ofSize: 18)
        self.contentView.addSubview(self.name)

        self.name.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        self.name.centerYAnchor.constraint(equalTo: self.centerYAnchor , constant: 0).isActive = true
        
       
        
        
    }
    
    
    
    
}
