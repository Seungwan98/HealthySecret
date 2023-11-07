//
//  ViewController.swift
//  MovieProject
//
//  Created by 양승완 on 2023/10/04.
//

import UIKit

class HomeViewController : UIViewController {
    
    
    
    
    lazy var mainStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [testLabel1, stackView2, testLabel3])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        return stackView
        
        
    }()
    
    
    let navigationBar : UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.backgroundColor = .white
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()
    
    lazy var stackView2 : UIStackView = {
        let stackView =  UIStackView(arrangedSubviews: [goButton , loginButton])
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
    
    
    var loginButton : UIButton = {
        
        let button = UIButton()
        button.setTitle("login", for: .normal)
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
    var testLabel3 : UILabel = {
        let label = UILabel()
        label.text = "test3"
        label.backgroundColor = .gray
        return label
        
    }()
    
    //터치 했을때 ingredientsController (API 호출 및 데이터 전송받는 컨트롤러로 이동)
    @IBAction func goTabBar(sender: UIButton ){
        
        navigationController?.pushViewController(IngredientsViewController(), animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI(){
        
        view.addSubview(mainStackView)
        
        
        goButton.addTarget(self, action:
                            #selector(goTabBar), for: .touchUpInside)
        
        mainStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        mainStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 10).isActive = true
        mainStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -10).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor , constant: -20
        ).isActive = true
        
        
        
      
        
        
        
    }
    
    
    
   
    




}



//class TabBarViewController : UITabBarController {
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//        // Do any additional setup after loading the view.
//        let homeVC = ViewController()
//        let searchVC = IngredientsController()
//
//        //각 tab bar의 viewcontroller 타이틀 설정
//
//        homeVC.title = "Home"
//        searchVC.title = "Search"
//
//        homeVC.tabBarItem.image = UIImage.init(systemName: "house")
//        searchVC.tabBarItem.image = UIImage.init(systemName: "magnifyingglass")
//
//        //self.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0);
//
//        // 위에 타이틀 text를 항상 크게 보이게 설정
//        homeVC.navigationItem.largeTitleDisplayMode = .always
//        searchVC.navigationItem.largeTitleDisplayMode = .always
//
//        // navigationController의 root view 설정
//        let navigationHome = UINavigationController(rootViewController: homeVC)
//        let navigationSearch = UINavigationController(rootViewController: searchVC)
//
//
//        navigationHome.navigationBar.prefersLargeTitles = true
//        navigationSearch.navigationBar.prefersLargeTitles = true
//
//        setViewControllers([navigationHome, navigationSearch ], animated: false)
//    }
//}

