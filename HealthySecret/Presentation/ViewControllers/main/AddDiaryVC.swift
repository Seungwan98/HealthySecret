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

class AddDiaryVC : UIViewController {
    
    let disposeBag = DisposeBag()

    private var viewModel : CalendarVM?

    
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
    
  
    
   
    
    let addDiaryTextView : UITextView = {
        // Create a TextView.
        let textView: UITextView = UITextView()

        textView.translatesAutoresizingMaskIntoConstraints = false
        // Round the corners.
        textView.backgroundColor = .lightGray.withAlphaComponent(0.2)

        // Set the size of the roundness.
        textView.layer.cornerRadius = 10

        textView.textAlignment = .left
        
        
        textView.font = UIFont.boldSystemFont(ofSize: 18)

        // Set font color.
        textView.textColor = UIColor.black

        // Set left justified.
        textView.textAlignment = NSTextAlignment.left

        // Automatically detect links, dates, etc. and convert them to links.
        textView.dataDetectorTypes = UIDataDetectorTypes.all
  

        // Make text uneditable.
        textView.isEditable = true

        
        textView.tintColor = .black
        return textView
    }()

        
    let bottomView : UIView = {
       let view = UIView()
       
       
       view.translatesAutoresizingMaskIntoConstraints = false
     
       return view
   }()
    
    private let addButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .black
        
        button.setTitle("기록 완료", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let firstLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .boldSystemFont(ofSize: 26)
        label.text = "오늘의 일기를\n기록하여 주세요."
        label.numberOfLines = 2
        return label
    }()
    
    private let secondLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .gray.withAlphaComponent(0.8)
        label.text = "오늘의 일기"
     
        return label
    }()
    
    
    init(viewModel : CalendarVM ){
        self.viewModel = viewModel
  
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        self.navigationController?.navigationBar.backgroundColor = .white

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setUI()
        setBindings()
        
    }
    
    
    
    
    

    
    
    func setUI(){
        
        self.view.addSubview(contentScrollView)
        self.view.addSubview(bottomView)
        
        self.contentScrollView.addSubview(contentView)
        
        bottomView.addSubview(addButton)

        
        contentView.addSubview(addDiaryTextView)
        contentView.addSubview(firstLabel)
        contentView.addSubview(secondLabel)
      
        
        
        

            
          
        
        
        
        NSLayoutConstraint.activate([
            
            bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 100),
            
            

            
            addButton.leadingAnchor.constraint(equalTo:bottomView.leadingAnchor , constant: 20),
            addButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20 ),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor , constant: -10 ),
        
            contentScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            
            contentView.topAnchor.constraint(equalTo: self.contentScrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.contentScrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.contentScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.contentScrollView.trailingAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 1000),
            
            
            
            self.contentView.widthAnchor.constraint(equalTo: self.contentScrollView.widthAnchor , multiplier: 1.0),

       
            firstLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            firstLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 20),
            
            secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor , constant: 60),
            secondLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 20),
           
     
            
            addDiaryTextView.topAnchor.constraint(equalTo: secondLabel.bottomAnchor , constant: 5),
            addDiaryTextView.leadingAnchor.constraint(equalTo:contentView.leadingAnchor , constant: 20),
            addDiaryTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -20 ),
            addDiaryTextView.heightAnchor.constraint(equalToConstant: 260 ),
            
            

         
            
            
            
        
        
        ])
      
  
    }
   
    
    
    
    
    
    func setBindings(){
        
        
        let input = CalendarVM.AddInput(addButtonTapped: self.addButton.rx.tap.asObservable() , diaryText: self.addDiaryTextView.rx.text.asObservable() )
        
        guard let output = self.viewModel?.addTransform(input: input, disposeBag1: disposeBag) else {return}

       
        output.writedText.bind(to: self.addDiaryTextView.rx.text).disposed(by: disposeBag)


        
       
        
    }
    
 
  
    
   
    




}



