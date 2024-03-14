//
//  ViewController.swift
//  MovieProject
//
//  Created by 양승완 on 2023/10/04.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController : UIViewController {
    
    let disposeBag = DisposeBag()

    private var viewModel : HomeVM?
    
    
    init(viewModel : HomeVM){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var checkBoxButton: UIButton = {
          let button = UIButton()
          button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
          button.isUserInteractionEnabled = false
          
          return button
      }()

    
    
    
    lazy var mainStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [testLabel1, stackView2, testImage])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        return stackView
        
        
    }()
    
  
    lazy var stackView2 : UIStackView = {
        let stackView =  UIStackView(arrangedSubviews: [checkBoxButton , logOutButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        
        
        return stackView
        
        
        
    }()
 
 
    var goButton : UIButton = {
        
        let button = UIButton()
        button.setTitle("식품검색", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .blue
        
        return button
        
    }()
    
    
    var logOutButton : UIButton = {
        
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .blue
        
        return button
        
    }()
    
    
    
    var testLabel1 : UILabel = {
        let label = UILabel()
        label.backgroundColor = .gray
        label.text = "test1"
        
        return label
        
    }()
    var testLabel2 : UILabel = {
        let label = UILabel()
        label.backgroundColor = .gray
        label.text = "test2"
        
        return label
        
    }()
    var testImage : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
        
    }()
    
    var rightBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                      style: .plain,
                                         target: HomeViewController.self, action: nil
                              )
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
        setBindings()
        
        
        
    }

    
    func setNavigationBar(){
        rightBarButton.tintColor = .white
        navigationItem.rightBarButtonItem = rightBarButton
    }
    func setUI(){
        view.backgroundColor = .systemGreen
        view.addSubview(mainStackView)
        mainStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        mainStackView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor,constant: 5).isActive = true
        mainStackView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor,constant: -5).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor , constant: -5
        ).isActive = true
        
        
      
        
        
        
    }
    
    
    
    func setBindings(){
        
        let input = HomeVM.Input(logoutButtonTapped: logOutButton.rx.tap.asObservable(),
                                 rightBarButtonTapped: rightBarButton.rx.tap.asObservable())
        
        
       
        
     
        
        guard let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag) else {return}
        output.testLabel.bind(to: testLabel1.rx.text).disposed(by: disposeBag)
        output.outputImage.subscribe(onNext: { data in
           print(data)
            if let data = data {  var image = UIImageView(image : UIImage(data: data))
                image.backgroundColor = .blue
                self.stackView2.addArrangedSubview(image)
                
            }
            
         
            
            
        }).disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.backgroundColor = .clear

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    
  
    
   
    




}



