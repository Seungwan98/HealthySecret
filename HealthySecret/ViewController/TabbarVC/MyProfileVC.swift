//
//  ViewController.swift
//  MovieProject
//
//  Created by 양승완 on 2023/10/04.
//

import UIKit
import RxCocoa
import RxSwift

class MyProfileVC : UIViewController {
    
    let disposeBag = DisposeBag()

    private var viewModel : MyProfileVM?
    
    
    init(viewModel : MyProfileVM){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.backgroundColor = .clear

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setBindings()
        
    }

    
    func setUI(){
        
        NSLayoutConstraint.activate([
        
        
        
        ])
  
    }
    
    
    
    func setBindings(){
        
        let input = MyProfileVM.Input()
        
        guard let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag) else {return}
        
    }
    
 
  
    
   
    




}



