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
import SnapKit

class AddDiaryVC : UIViewController {
    
    let disposeBag = DisposeBag()

    private var viewModel : CalendarVM?

    
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView : UIView = {
        let view = UIView()
        return view
    }()
    
  
    
   
    
    let addDiaryTextView : UITextView = {
        // Create a TextView.
        let textView: UITextView = UITextView()

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
       
       return view
   }()
    
    private let addButton : UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .black
        
        button.setTitle("기록 완료", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let firstLabel : UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 26)
        label.text = "오늘의 일기를\n기록하여 주세요."
        label.numberOfLines = 2
        return label
    }()
    
    private let secondLabel : UILabel = {
        let label = UILabel()
        
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
      
        
        
        

            
          
        
        bottomView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalTo(self.view)
            $0.height.equalTo(100)
        }
        addButton.snp.makeConstraints{
            $0.leading.trailing.equalTo(bottomView).inset(20)
            $0.height.equalTo(60)
            $0.centerY.equalTo(bottomView).offset(-10)
        }
        contentScrollView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(self.view)
            $0.bottom.equalTo(self.bottomView.snp.top)
        }  
        contentView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.width.equalTo(self.contentScrollView)
            $0.height.equalTo(1000)
   
        }
        firstLabel.snp.makeConstraints{
            $0.top.equalTo(contentView)
            $0.leading.equalTo(contentView).inset(20)
        }    
        secondLabel.snp.makeConstraints{
            $0.top.equalTo(firstLabel.snp.bottom).offset(60)
            $0.leading.equalTo(contentView).inset(20)
        }
        addDiaryTextView.snp.makeConstraints{
            $0.top.equalTo(secondLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(contentView).inset(20)
            $0.height.equalTo(260)
        }
   
      
  
    }
   
    
    
    
    
    
    func setBindings(){
        
        
        let input = CalendarVM.AddInput(addButtonTapped: self.addButton.rx.tap.asObservable() , diaryText: self.addDiaryTextView.rx.text.asObservable() )
        
        guard let output = self.viewModel?.addTransform(input: input, disposeBag1: disposeBag) else {return}

       
        output.writedText.bind(to: self.addDiaryTextView.rx.text).disposed(by: disposeBag)


        
       
        
    }
    
 
  
    
   
    




}



