//
//  ChangeProfileVC.swift
//  MovieProject
//
//  Created by 양승완 on 2023/10/04.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture

class SettingVC : UIViewController {
    
    let disposeBag = DisposeBag()

    private var viewModel : MyProfileVM?
    
    
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let logoutButton : UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 20)

        return view
    }()
    private let secessionButton : UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 80)


        return view
        
    }()
    private let sample2 : UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 40)

//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.heightAnchor.constraint(equalToConstant: 4).isActive = true

        return view
        
    }()

    
    private lazy var stackViewValues : [UIView] = [logoutButton , secessionButton ]
    
    private lazy var informationView : UIStackView = {
        let view = UIStackView(arrangedSubviews: stackViewValues)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 5
        view.distribution = .fillProportionally
        return view
        
    }()

    

    
    init(viewModel : MyProfileVM){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "설정"
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        self.navigationController?.navigationBar.backgroundColor = .white

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setStackView()
        setBindings()
        
    }
    
    let texts = ["로그아웃" , "회원탈퇴"]
    var idx = 0
    func setStackView(){
       _ = stackViewValues.map{
           
           
           let label = UILabel()
           let image = UIImageView(image:UIImage(named: "arrow.png"))

           
           $0.addSubview(label)
           $0.addSubview(image)
           
           label.translatesAutoresizingMaskIntoConstraints = false
           label.backgroundColor = .white
           label.text = texts[idx]
           idx = idx + 1
           label.textAlignment = .left

           label.font = .boldSystemFont(ofSize: 16)
           label.centerYAnchor.constraint(equalTo: $0.centerYAnchor).isActive = true
           label.leadingAnchor.constraint(equalTo: $0.leadingAnchor , constant: 5).isActive = true
           
           
           image.translatesAutoresizingMaskIntoConstraints = false
           image.centerYAnchor.constraint(equalTo: $0.centerYAnchor).isActive = true
           image.trailingAnchor.constraint(equalTo: $0.trailingAnchor , constant: -5).isActive = true
           image.widthAnchor.constraint(equalToConstant: 14).isActive = true
           image.heightAnchor.constraint(equalToConstant: 14).isActive = true
           
         
           
     
           

           
           
            
        }
    }

    
    func setUI(){
        
        self.view.addSubview(contentScrollView)

        self.contentScrollView.addSubview(contentView)
     
       
        
        self.contentView.addSubview(informationView)

            
          
        
        
        
        NSLayoutConstraint.activate([
            
        
        
            contentScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            
            contentView.topAnchor.constraint(equalTo: self.contentScrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.contentScrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.contentScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.contentScrollView.trailingAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 900),
            self.contentView.widthAnchor.constraint(equalTo: self.contentScrollView.widthAnchor , multiplier: 1.0),

            informationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 20),
            informationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -20),
            informationView.topAnchor.constraint(equalTo: contentView.topAnchor , constant: 10),
            informationView.heightAnchor.constraint(equalToConstant: 100),
            

         
            
            
            
            
        
        
        ])
      
  
    }
   
    
    
    
    
    
    func setBindings(){
        let input = MyProfileVM.SettingInput(viewWillApearEvent: self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }).asObservable() , logoutTapped: logoutButton.rx.tapGesture().when(.recognized).asObservable(), secessionTapped: secessionButton.rx.tapGesture().when(.recognized).asObservable())

        
        
        
        guard let output = viewModel?.settingTransform(input: input, disposeBag: self.disposeBag) else { return }
    }
    
 
  
    
   
    




}



