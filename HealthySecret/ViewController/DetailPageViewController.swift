//
//  DetailPageViewController.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/20.
//

import UIKit

class DetailPageViewController: UIViewController {
    
    private let contentScrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.backgroundColor = .white
            scrollView.showsVerticalScrollIndicator = false
            
            return scrollView
        }()
    
    private let contentView: UIView = {
           let view = UIView()
           view.translatesAutoresizingMaskIntoConstraints = false
           return view
       }()

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubView()
        
        }
    

    func addSubView(){
        self.view.addSubview(contentScrollView)
        self.view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
                   contentScrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
                   contentScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                   contentScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                   contentScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                   contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
                               contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
                               contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
                               contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
                   contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor)
        ])
    }

}
