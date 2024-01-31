//
//  DetailPageViewController.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/20.
//

import UIKit
import Charts
import RxSwift
import SwiftUI
import RxCocoa
import RxGesture

class DiaryViewController : UIViewController {
    
    let viewModel : DiaryVM?
    let disposeBag = DisposeBag()
    init(viewModel: DiaryVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    
    
    var pieChart : PieChartView = {
        let pieChart = PieChartView()
        
        pieChart.noDataText = ""
        pieChart.noDataFont = .boldSystemFont(ofSize: 20)
        pieChart.noDataTextColor = .white
        pieChart.noDataTextAlignment = .left
        pieChart.highlightPerTapEnabled = false
        
        
        
        pieChart.holeRadiusPercent = 0.9
        pieChart.holeColor? =  .clear
        pieChart.legend.enabled = false
        
        return pieChart
        
        
    }()
    
    
    
    
    
    let nutrientsLabel1 = UILabel()
    let nutrientsLabel2 = UILabel()
    let nutrientsLabel3 = UILabel()
    lazy var nutrientsLabelsArr : [UILabel] =  [self.nutrientsLabel1 , self.nutrientsLabel2 , self.nutrientsLabel3]
    
    
    
    //메인 차트뷰
    var chartView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.brown.withAlphaComponent(0.5)
        view.frame = CGRect(x: 0, y: 0, width: 110, height: 100)
        
        let leftLabel = UILabel()
        leftLabel.font = .boldSystemFont(ofSize: 22)
        leftLabel.text = "오늘 하루"
        leftLabel.textColor = .white
        
        leftLabel.translatesAutoresizingMaskIntoConstraints = false

        
  
        
        
        view.addSubview(leftLabel)
        
        
        leftLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 12).isActive = true
        leftLabel.topAnchor.constraint(equalTo: view.topAnchor , constant: 12).isActive = true
        
        //view.layer.cornerRadius = 20
        return view
        
        
    }()
    
    
    
    
    
    lazy var buttonStackView : UIStackView = {
        let view = UIStackView(arrangedSubviews: [mealButtons[0] , mealButtons[1]] )
       //
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 10
        view.distribution = .fillEqually
        return view
        
    }()
    
    lazy var buttonStackView2 : UIStackView = {
        let view = UIStackView(arrangedSubviews: [mealButtons[2] , mealButtons[3]] )
      //  view.backgroundColor = UIColor(red: 0.686, green: 0.776, blue: 0.627, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 10
        view.distribution = .fillEqually
        return view
        
    }()
    
    
    
    lazy var chartStackview : UIStackView = {
        let view = UIStackView(arrangedSubviews: [ pieChart , majorView ])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 20
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    
    
    
    
    lazy var majorLabelsStackView : UIStackView = {
        let view = UIStackView(arrangedSubviews: nutrientsLabelsArr )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillEqually
        return view
    }()
    
    
    let nutrientsLabel11 = UILabel()
    let nutrientsLabel21 = UILabel()
    let nutrientsLabel31 = UILabel()
    lazy var nutrientsLabelsArr2 : [UILabel] =  [self.nutrientsLabel11 , self.nutrientsLabel21 , self.nutrientsLabel31]
    lazy var majorLabelsStackView2 : UIStackView = {
        
        let view = UIStackView(arrangedSubviews: nutrientsLabelsArr2 )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fillEqually
        return view
        
    }()
    
    
    
    var majorImageArr = [ UIImageView(image: UIImage(named: "firstDout.png")), UIImageView(image: UIImage(named: "secondDout.png")), UIImageView(image: UIImage(named: "thirdDout.png")) ]
    
    
    lazy var majorImageStackView : UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.axis = .vertical
        view.spacing = 10
        view.distribution = .fillEqually
        view.alignment = .center
        return view
    }()
    
    
    
    
    
    
    
    var kcalLabel = UILabel()
    var carbohydratesLabel = UILabel()
    var proteinLabel = UILabel()
    var provinceLabel = UILabel()
    var sugarsLabel = UILabel()
    var sodiumLabel = UILabel()
    var cholesterolLabel = UILabel()
    var fattyAcidLabel = UILabel()
    var transFatLabel = UILabel()
    
    lazy var ingredientsLabels : [UILabel] = [ kcalLabel , carbohydratesLabel , proteinLabel , provinceLabel , sugarsLabel , sodiumLabel , cholesterolLabel , fattyAcidLabel , transFatLabel ]
    
    
//    var line : UIImageView = {
//        let line = UIImageView(image: UIImage(named: "line.png"))
//        line.translatesAutoresizingMaskIntoConstraints = false
//        return line
//    }()
//    
    
    lazy var ingredientsStackView : UIStackView = {
        _ = self.ingredientsLabels.map { $0.isHidden = true }
        let labels = self.ingredientsLabels.map({ (label : UILabel ) -> UILabel in
            label.font = UIFont.boldSystemFont(ofSize: 12)
            return label
        })
        let view = UIStackView(arrangedSubviews: labels)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = UIColor(red: 0.686, green: 0.776, blue: 0.627, alpha: 1)
        view.spacing = 1
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .center
//        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    
    
    var breakFastBottomImage = UIImageView()
    var lunchBottomImage =  UIImageView()
    var dinnerBottomImage =  UIImageView()
    var snackBottomImage =  UIImageView()
    
    lazy var mealBottomImages = [breakFastBottomImage ,lunchBottomImage , dinnerBottomImage , snackBottomImage]
    
    lazy var mealButtonViews = [breakfastButtonView , lunchButtonView , dinnerButtonView , snackButtonView]
    
    lazy var breakfastButtonView : UIView = {
        
        let buttonView = UIView()
        let backgroundImageView = UIImageView(image:UIImage(named:"breakFast.png"))
        let bottomImageView = UIImageView()
        let label = UILabel()
        
        
        
        label.text = "아침"
        label.font = .boldSystemFont(ofSize: 18)

    
        
        label.translatesAutoresizingMaskIntoConstraints = false
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        buttonView.addSubview(backgroundImageView)
        buttonView.addSubview(label)
        buttonView.addSubview(breakfastLabel)
        
        
        label.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 24).isActive = true
        label.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 24).isActive = true
        
        breakfastLabel.topAnchor.constraint(equalTo: label.topAnchor).isActive = true
        breakfastLabel.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor ,  constant: -22).isActive = true

        
        backgroundImageView.widthAnchor.constraint(equalTo: buttonView.widthAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalTo: buttonView.heightAnchor).isActive = true
        
        
        return buttonView
    }()
    lazy var lunchButtonView : UIView = {
        let buttonView = UIView()
        let backgroundImageView = UIImageView(image:UIImage(named:"lunch.png"))
        let bottomImageView = UIImageView()
        let label = UILabel()
        
        
        label.text = "점심"
        label.font = .boldSystemFont(ofSize: 18)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        buttonView.addSubview(backgroundImageView)
        buttonView.addSubview(label)
        
        label.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 24).isActive = true
        label.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 24).isActive = true
        
        
        backgroundImageView.widthAnchor.constraint(equalTo: buttonView.widthAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalTo: buttonView.heightAnchor).isActive = true
        return buttonView
        
    }()
    lazy var dinnerButtonView : UIView = {
        let buttonView = UIView()
        let backgroundImageView = UIImageView(image:UIImage(named:"dinner.png"))
        let bottomImageView = UIImageView()
        let label = UILabel()
        
        
        label.text = "저녁"
        label.font = .boldSystemFont(ofSize: 18)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        buttonView.addSubview(backgroundImageView)
        buttonView.addSubview(label)
        
        label.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 24).isActive = true
        label.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 24).isActive = true
        
        
        backgroundImageView.widthAnchor.constraint(equalTo: buttonView.widthAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalTo: buttonView.heightAnchor).isActive = true
        
        return buttonView
        
    }()
    
    lazy var snackButtonView : UIView = {
        
        let buttonView = UIView()
        let backgroundImageView = UIImageView(image:UIImage(named:"snack.png"))
        let bottomImageView = UIImageView()
        let label = UILabel()
        
        
        
        label.text = "간식"
        label.font = .boldSystemFont(ofSize: 18)

    
        
        label.translatesAutoresizingMaskIntoConstraints = false
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        buttonView.addSubview(backgroundImageView)
        buttonView.addSubview(label)
        buttonView.addSubview(snackLabel)
        
        
        label.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 24).isActive = true
        label.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 24).isActive = true
        
        snackLabel.topAnchor.constraint(equalTo: label.topAnchor).isActive = true
        snackLabel.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor ,  constant: -22).isActive = true

        
        backgroundImageView.widthAnchor.constraint(equalTo: buttonView.widthAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalTo: buttonView.heightAnchor).isActive = true
        
        
        return buttonView
    }()
    
    
    lazy var mealLabels = [breakfastLabel , lunchLabel , dinnerLabel , snackLabel ]
    
    var breakfastLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    var lunchLabel : UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)

        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    var dinnerLabel : UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)

        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var snackLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    
    lazy var mealButtons = [breakfastButton  , lunchButton , dinnerButton , snackButton]
    
    var breakfastButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    
    
    var lunchButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        return button
    }()
    var dinnerButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        return button
    }()
    
    
    
      var snackButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        return button
    }()
    
    
    
    
    
    
    
    var sangsaeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.brown.withAlphaComponent(0.15)
        button.setTitle("상세 정보", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 25
        return button
        
    }()
    
    var majorView : UIView = {
        let view = UIView()
        return view
        
    }()
    
    lazy var calendarLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        return label
        
    }()
    
    
    
    var ingredientsLabelArr : [UILabel] = []
    
    
    var ingredientsName : [String] = [  "탄수화물" , "단백질" , "지방" ]
    
    var ingredientsPercent : [Double] = [ 0.0 , 0.0 , 0.0]
    
    var ingredientsColor : [UIColor] = [   UIColor(red: 0.686, green: 0.776, blue: 0.627, alpha: 1),  UIColor(red: 0.487, green: 0.555, blue: 0.448, alpha: 1) , UIColor(red: 0.835, green: 0.886, blue: 0.8, alpha: 1) ]
    
    
    
    var rightBarButton : UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "chevron.right"),
                                        style: .plain,
                                        target: DiaryViewController.self, action: nil)
        barButton.tintColor = .black
        
        return barButton
        
        
        
    }()
    
    
    var leftBarButton : UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                        style:  .plain,
                                        target:  DiaryViewController.self , action: nil)
        barButton.tintColor = .black
        return barButton
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        addSubView()
        
        setBinds()
        
        
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.leftBarButtonItem = leftBarButton
    
        //UIColor(red: 0.09, green: 0.176, blue: 0.031, alpha: 1)
        
        
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    var exerciseAddButton : UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
    }()
    
    let buttonView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.09, green: 0.18, blue: 0.03, alpha: 1)
        
        let leftLabel = UILabel()
        leftLabel.font = .boldSystemFont(ofSize: 22)
        leftLabel.text = "나의 식사"
        leftLabel.textColor = UIColor(red: 0.949, green: 0.918, blue: 0.886, alpha: 1)
        
        
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false

        
  
        
        
        view.addSubview(leftLabel)
        
        
        leftLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 12).isActive = true
        leftLabel.topAnchor.constraint(equalTo: view.topAnchor , constant: 12).isActive = true
        
        return view
        
        
        
    }()
    
    var minuteLabel = UILabel()
    var calorieLabel = UILabel()
    lazy var exerciseView : UIView = {
        let image = UIImageView(image: UIImage(named: "운동하는유미.png"))
        let view = UIView()
        let centerLabel = UILabel()
        
        
        let leftLabel = UILabel()
        
        centerLabel.font = .boldSystemFont(ofSize: 18)
        centerLabel.text = "오늘 운동 시간은?"
        centerLabel.textColor = .white
        
        
        
        self.minuteLabel.font = .boldSystemFont(ofSize: 40)
        self.minuteLabel.text = "분"
        self.minuteLabel.textColor = .white
        
        self.calorieLabel.font = .boldSystemFont(ofSize: 20)
        self.calorieLabel.text = ""
        self.calorieLabel.textColor = .white
        
        
        leftLabel.font = .boldSystemFont(ofSize: 22)
        leftLabel.text = "나의 활동"
        leftLabel.textColor = .white
        
        
        
        
      //  view.layer.cornerRadius = 20
        view.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        //UIColor(red: 0.949, green: 0.918, blue: 0.886, alpha: 1)

        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        centerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        minuteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(image)
        view.addSubview(leftLabel)
        view.addSubview(centerLabel)
        view.addSubview(self.minuteLabel)
        view.addSubview(self.exerciseAddButton)
        
        centerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor , constant: -140).isActive = true
        
        minuteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        minuteLabel.centerYAnchor.constraint(equalTo: centerLabel.centerYAnchor , constant: 40).isActive = true
        
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: view.centerYAnchor , constant: 0 ).isActive = true
        
        leftLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 12).isActive = true
        leftLabel.topAnchor.constraint(equalTo: view.topAnchor , constant: 12).isActive = true
        
        
        
        return view
    }()
    
    lazy var testView : UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.686, green: 0.776, blue: 0.627, alpha: 1)
        return view
    }()
    
    
    
    var piechartCenterLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "kcal"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    var morningCheckImageView : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "check.png"))
        imageView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    
    
    
    
    
    func staggerAnimations() {
        let duration1 = 0.4
        let duration2 = 0.2
        
        // initially hide...
        
        
        self.ingredientsStackView.alpha = 0
        
        _ = self.ingredientsLabels.map { $0.alpha = 0 }
        
        
        let firstAnimation = UIViewPropertyAnimator(duration: duration1, curve: .easeInOut ) { [self] in
            
            ingredientsStackView.isHidden = !showAll
            
            _ = ingredientsLabels.map { $0.isHidden = !showAll }
            
            
            
        }
        
        firstAnimation.addCompletion { position in
            if position == .end {
                // followed by alpha
                
                
                let secondAnimation = UIViewPropertyAnimator(duration: duration2, curve: .easeInOut) {
                    
                    self.ingredientsStackView.alpha = 1
                    
                    
                    _ = self.ingredientsLabels.map { $0.alpha = 1 }
                    if(self.showAll) {
                        
                        self.contentScrollView.contentSize.height = self.contentScrollView.contentSize.height + 400
                        
                        
                        self.buttonView.frame = CGRect(x: self.buttonView.frame.minX, y: self.ingredientsStackView.frame.maxY, width: self.buttonView.frame.width, height: self.buttonView.frame.height)
                        
                        
                        
                        
                        self.exerciseView.frame = CGRect(x: self.exerciseView.frame.minX, y: self.buttonView.frame.maxY, width: self.exerciseView.frame.width, height: self.exerciseView.frame.height)
                        
                    }
                    else {
                        
                        self.contentScrollView.contentSize.height = self.contentScrollView.contentSize.height - 400
                        
                        
                        self.sangsaeButton.setImage(UIImage(named: "sangsaeButton.png"), for: .normal)
                        
                        self.buttonView.frame = CGRect(x: self.buttonView.frame.minX, y: self.chartView.frame.maxY, width: self.buttonView.frame.width, height: self.buttonView.frame.height)
                        
                        
                        self.exerciseView.frame = CGRect(x: self.exerciseView.frame.minX, y: self.buttonView.frame.maxY, width: self.exerciseView.frame.width, height: self.exerciseView.frame.height)
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                }
                
                secondAnimation.startAnimation()
                
            }
        }
        firstAnimation.startAnimation()
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
            self.preventButtonTouch = false
        }
        
    }
    var showAll = false
    var preventButtonTouch = false
    
    
    
    
    @objc
    func pressed(){

        if preventButtonTouch == true {
            return
            
        }
        preventButtonTouch = true
        
        if(showAll == false){
            self.sangsaeButton.setImage(UIImage(named: "sangsaeButton2.png"), for: .normal)
            
        }
        else{
            self.sangsaeButton.setImage(UIImage(named: "sangsaeButton.png"), for: .normal)
            
            
        }
        
        
        
        //let showAll = true
        //        let animation = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) { [self] in
        //            _ = self.ingredientsLabels.map { $0.isHidden = !showAll }
        //        }
        //        animation.startAnimation()
        //
        
        showAll = !showAll
        staggerAnimations()
        
        
        
        
        //
        //        self.testView.frame  = CGRect(x: self.sangsaeButton.frame.minX , y: self.sangsaeButton.frame.maxY , width: self.sangsaeButton.frame.width, height: 0)
        
        
        
        
        
        //        UIView.animate(withDuration: 0.2, delay: 0.001 , options: .transitionCurlDown ) {
        //
        //            self.testView.frame  = CGRect(x: self.sangsaeButton.frame.minX , y: self.sangsaeButton.frame.maxY , width: self.sangsaeButton.frame.width, height: 320)
        
        
        
        
        
        
        //            let labels = self.ingredientsLabels.map({ (label : UILabel ) -> UILabel in
        //                self.ingredientsStackView.addArrangedSubview(label)
        //
        //                label.font = UIFont.boldSystemFont(ofSize: 12)
        //                return label
        //            })
        
        //            self.ingredientsStackView.frame.size = CGSize(width: self.ingredientsStackView.frame.width , height: 100)
        
        //            stackv.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        //        } completion: { _ in
        
        //            self.view.addSubview(self.ingredientsStackView)
        //
        //
        //            _ = self.ingredientsLabels.map({ (label : UILabel ) -> UILabel in
        //                self.ingredientsStackView.addArrangedSubview(label)
        //                label.font = UIFont.boldSystemFont(ofSize: 12)
        //                return label
        //            })
        //
        
        
        
        //
        //
        
        //
        //            self.buttonStackView.frame = CGRect(x: self.sangsaeButton.frame.minX , y: self.testView.frame.maxY , width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height)
        
        
        
        
        
    }
    
    
    
    
    func setButtons(){
        //let tapesture = UITapGestureRecognizer (target: self, action: nil)
        
        
        for i in 0..<4{
            let view = mealButtonViews[i]
            let image = mealBottomImages[i]
            
            //view.addGestureRecognizer(tapesture)
            
            view.addSubview(image)
            view.isUserInteractionEnabled = false
            view.isExclusiveTouch = false
            
            mealButtons[i].addSubview(view)
            
            image.translatesAutoresizingMaskIntoConstraints = false
            
            
            image.bottomAnchor.constraint(equalTo: view.bottomAnchor , constant: -20).isActive = true
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -20).isActive = true
            image.heightAnchor.constraint(equalToConstant: 20).isActive = true
            image.widthAnchor.constraint(equalToConstant: 20).isActive = true
            
            
            view.heightAnchor.constraint(equalTo: mealButtons[i].heightAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: mealButtons[i].widthAnchor).isActive = true
            
            
            
            
        }
        
        
        
        
    }
    
    
    func addSubView(){
        self.navigationItem.titleView = calendarLabel
        self.view.backgroundColor = .white

        
        self.view.addSubview(contentScrollView)
        
        self.contentScrollView.addSubview(contentView)
        
        
        
        self.contentView.addSubview(chartView)
        self.contentView.addSubview(chartStackview)
        self.contentView.addSubview(buttonView)
        self.contentView.addSubview(exerciseView)
        self.contentView.addSubview(sangsaeButton)
     //   self.contentView.addSubview(line)
        self.contentView.addSubview(testView)
        self.contentView.addSubview(ingredientsStackView)
        
        self.buttonView.addSubview(buttonStackView)
        self.buttonView.addSubview(buttonStackView2)
        
//        chartView.layer.shadowOpacity = 1
//        chartView.layer.shadowRadius = 1
//        chartView.layer.shadowOffset = CGSize(width: 0, height: 4)
//        chartView.layer.shadowPath = nil
        
        
        self.majorView.addSubview(majorLabelsStackView)
        self.majorView.addSubview(majorLabelsStackView2)
        self.majorView.addSubview(majorImageStackView)
        self.majorView.addSubview(piechartCenterLabel)
        
        setButtons()
        
        
        sangsaeButton.addTarget(self, action: #selector(pressed), for: .touchDown )
        
        let imgArr = [UIImage(named: "firstDout") , UIImage(named: "secondDout") , UIImage(named: "thirdDout")]
        let attributedString =  [NSMutableAttributedString(string: ""),NSMutableAttributedString(string: ""),NSMutableAttributedString(string: "")]
        let imageAttachment = [ NSTextAttachment(),NSTextAttachment(),NSTextAttachment()]
      
       
        
 
        
       
        
        
        
        
        
 
        
        
        for i in 0 ..< 3{
            imageAttachment[i].image = imgArr[i]
            imageAttachment[i].bounds = CGRect(x: 0, y: 0, width: 12, height: 12)
            
            
            attributedString[i].append(NSAttributedString(attachment: imageAttachment[i]))
            attributedString[i].append(NSAttributedString(string: "  \(ingredientsName[i])"))
            
            nutrientsLabelsArr[i].attributedText = attributedString[i]

            
            
            nutrientsLabelsArr[i].font =  UIFont.boldSystemFont(ofSize: 15)
            nutrientsLabelsArr2[i].font =  UIFont.boldSystemFont(ofSize: 15)
            nutrientsLabelsArr[i].textColor = .white
            nutrientsLabelsArr2[i].textColor = .white
            
            
        }
        
       
        // self.chartView.addSubview(self.pieChart)
        
        
        
        
        
        
        NSLayoutConstraint.activate([
            
            
            
            
            self.contentScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor ),
            self.contentScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.contentScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.contentScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            self.contentView.topAnchor.constraint(equalTo: self.contentScrollView.topAnchor ),
            self.contentView.leadingAnchor.constraint(equalTo: self.contentScrollView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.contentScrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.contentScrollView.bottomAnchor),
            
            self.contentView.widthAnchor.constraint(equalTo: self.contentScrollView.widthAnchor , multiplier: 1.0),
            
            
            self.piechartCenterLabel.centerXAnchor.constraint(equalTo: pieChart.centerXAnchor),
            self.piechartCenterLabel.centerYAnchor.constraint(equalTo: pieChart.centerYAnchor , constant: 9),
            
           
            
//
//            self.line.topAnchor.constraint(equalTo: self.chartView.topAnchor , constant: 45  ),
//            self.line.leadingAnchor.constraint(equalTo: self.chartStackview.leadingAnchor , constant: 20),
//            self.line.trailingAnchor.constraint(equalTo: self.chartStackview.trailingAnchor , constant: -20),
            
            
            
            
            
            self.majorLabelsStackView.widthAnchor.constraint(equalToConstant: 80),
            self.majorLabelsStackView.heightAnchor.constraint(equalToConstant: 73 ),
            self.majorLabelsStackView.centerYAnchor.constraint(equalTo: majorView.centerYAnchor ) ,
            self.majorLabelsStackView.leadingAnchor.constraint(equalTo: majorView.leadingAnchor ),
            
            self.majorLabelsStackView2.widthAnchor.constraint(equalToConstant: 66),
            self.majorLabelsStackView2.heightAnchor.constraint(equalToConstant: 73 ),
            self.majorLabelsStackView2.centerYAnchor.constraint(equalTo: majorView.centerYAnchor ),
            self.majorLabelsStackView2.leadingAnchor.constraint(equalTo: majorLabelsStackView.trailingAnchor , constant : 0),
            
            
            
            
            
            self.chartView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor ),
            self.chartView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            self.chartView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor, constant : 0),
            self.chartView.heightAnchor.constraint(equalToConstant: 400),
            
            
            
            self.sangsaeButton.heightAnchor.constraint(equalToConstant: 40),
            self.sangsaeButton.topAnchor.constraint(equalTo: self.chartStackview.safeAreaLayoutGuide.bottomAnchor, constant: 5),
            self.sangsaeButton.leadingAnchor.constraint(equalTo: self.chartStackview.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.sangsaeButton.trailingAnchor.constraint(equalTo: self.chartStackview.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            
            self.ingredientsStackView.topAnchor.constraint(equalTo: self.chartView.bottomAnchor ),
            // self.ingredientsStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor ,constant: -100 ),
            self.ingredientsStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor ) ,
            self.ingredientsStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor ) ,
            self.ingredientsStackView.heightAnchor.constraint(equalToConstant: 400),
            
            
            
            self.chartStackview.centerXAnchor.constraint(equalTo: self.chartView.centerXAnchor ),
            self.chartStackview.centerYAnchor.constraint(equalTo : self.chartView.centerYAnchor , constant: -70),
            self.chartStackview.widthAnchor.constraint(equalToConstant: 400  ),
            self.chartStackview.heightAnchor.constraint(equalToConstant:  200 ),
            
            
            
            self.buttonStackView.topAnchor.constraint(equalTo: self.buttonView.topAnchor , constant: 40),
            self.buttonStackView.leadingAnchor.constraint(equalTo: self.buttonView.safeAreaLayoutGuide.leadingAnchor  ,constant: 20 ),
            self.buttonStackView.trailingAnchor.constraint(equalTo: self.buttonView.safeAreaLayoutGuide.trailingAnchor , constant: -20 ),
            self.buttonStackView.heightAnchor.constraint(equalToConstant: 150),
            
            
            self.buttonStackView2.topAnchor.constraint(equalTo: self.buttonStackView.bottomAnchor , constant: 0),
            self.buttonStackView2.leadingAnchor.constraint(equalTo: self.buttonView.safeAreaLayoutGuide.leadingAnchor  ,constant: 20 ),
            self.buttonStackView2.trailingAnchor.constraint(equalTo: self.buttonView.safeAreaLayoutGuide.trailingAnchor , constant: -20 ),
            self.buttonStackView2.heightAnchor.constraint(equalToConstant: 150),
            
            
            
            self.buttonView.topAnchor.constraint(equalTo: self.chartView.bottomAnchor ),
            self.buttonView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor ),
            self.buttonView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor ),
            self.buttonView.heightAnchor.constraint(equalToConstant: 400),
            
            
            self.exerciseView.topAnchor.constraint(equalTo: buttonView.bottomAnchor , constant: 0),
            self.exerciseView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor ,constant: 0 ),
            self.exerciseView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor ,constant: 0),
            self.exerciseView.heightAnchor.constraint(equalToConstant: 400),
            self.exerciseView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            
            
            
            
            
            
            
        ])
        
        
        
        
        
    }
    
    
    
    func setBinds(){
        
        let breakfast = breakfastButton.rx.tap.map { _ in return UserDefaults.standard.set("아침식사", forKey: "meal")}
        let lunch = lunchButton.rx.tap.map {  _ in return UserDefaults.standard.set("점심식사", forKey: "meal")}
        let dinner = dinnerButton.rx.tap.map {  _ in return UserDefaults.standard.set("저녁식사", forKey: "meal")}
        let snack = snackButton.rx.tap.map {  _ in return UserDefaults.standard.set("간식", forKey: "meal")}
        
        let tags = Observable.of(breakfast, lunch , dinner , snack).merge()
        
        
        let input = DiaryVM.Input( viewWillApearEvent :  self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }).asObservable(),
                                   mealButtonsTapped :
                                    tags.asObservable()  , leftBarButtonTapped: calendarLabel.rx.tapGesture() , rightBarButtonTapped: rightBarButton.rx.tap.asObservable() )
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {return}
        //        output.searchedIngredients.subscribe(onNext: { ingredient in
        //            _ = ingredient.map { row in
        //            }
        //        }).disposed(by: disposeBag)
        
        
        
        output.date.subscribe(onNext: { date in
            
            self.calendarLabel.attributedText = date
            
            
        }).disposed(by: disposeBag)
        
        output.checkBreakFast.asDriver().drive(onNext: { [weak self] valid in
            print("breakfast")
            if valid {
                
                self?.breakFastBottomImage.image = UIImage(named: "check.png")
            }else{
                self?.breakFastBottomImage.image = UIImage(named: "add.png")
                
            }
            
        }).disposed(by: disposeBag)
        
        output.checkLunch.asDriver().drive(onNext: { [weak self] valid in
            print("lunch")
            
            if valid {
                
                self?.lunchBottomImage.image = UIImage(named: "check.png")
            }else{
                self?.lunchBottomImage.image = UIImage(named: "add.png")
                
            }
            
        }).disposed(by: disposeBag)
        
        output.checkDinner.asDriver().drive(onNext: { [weak self] valid in
            print("dinner")
            
            if valid {
                
                self?.dinnerBottomImage.image = UIImage(named: "check.png")
            }else{
                self?.dinnerBottomImage.image = UIImage(named: "add.png")
                
            }
            
        }).disposed(by: disposeBag)
        
        output.checkSnack.asDriver().drive(onNext: { [weak self] valid in
            print("snack")
            
            if valid {
                
                self?.snackBottomImage.image = UIImage(named: "check.png")
            }else{
                self?.snackBottomImage.image = UIImage(named: "add.png")
                
            }
            
        }).disposed(by: disposeBag)
        
        
        
        output.totalIngredients.subscribe(onNext: {
            total in
            
            print("\(total)  output")
            
            let totalValues = (total["carbohydrates"]! * 4) + (total["protein"]! * 4) + (total["province"]! * 9)
            
            
            
            if(totalValues != 0.0){
                
                let carbohydratesPer = total["carbohydrates"]!  * 4 / totalValues * 100
                let proteinPer =  total["protein"]!  * 4 / totalValues * 100
                let provincePer =  total["province"]!  * 9 / totalValues * 100
                self.ingredientsPercent[0] = (carbohydratesPer)
                self.ingredientsPercent[1] = (proteinPer)
                self.ingredientsPercent[2] = (provincePer)
                
                self.ingredientsColor =  [   UIColor(red: 0.686, green: 0.776, blue: 0.627, alpha: 1),  UIColor(red: 0.487, green: 0.555, blue: 0.448, alpha: 1) , UIColor(red: 0.835, green: 0.886, blue: 0.8, alpha: 1) ]
                
                
                
                self.setPieData(pieChartView: self.pieChart, pieChartDataEntries: self.entryData(values: self.ingredientsPercent , dataPoints: []))
            }
            else {
                
                _ = self.ingredientsPercent.map({ $0 * 0 })
                
                self.ingredientsColor = [.lightGray]
                self.setPieData(pieChartView: self.pieChart, pieChartDataEntries: self.entryData(values: [1] , dataPoints: []))
            }
            
            
            
            
            
            
            
            
            
            
            
            for i in 0 ..< self.ingredientsPercent.count  {
                self.nutrientsLabelsArr2[i].text = (String(format: "%.2f" , self.ingredientsPercent[i]) + "%" )
                
                
            }
            
            
            
            
            
            
            
            let attrString = NSAttributedString(string: String(total["kcal"]!) + "\n" ,   attributes: [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15) , .foregroundColor: UIColor.white as Any ])
            
            
            
            self.pieChart.centerAttributedText = attrString
            
            self.kcalLabel.text = " 칼로리: " + String(total["kcal"]!) + "kcal"
            self.carbohydratesLabel.text = " 탄수화물: " + String(total["carbohydrates"]!) + "g"
            self.proteinLabel.text = " 단백질: " + String(total["protein"]!) + "g"
            self.provinceLabel.text = " 지방: " + String(total["province"]!) + "g"
            self.sugarsLabel.text = " 당류: " + String(total["sugars"]!) + "g"
            self.sodiumLabel.text = " 나트륨: " + String(total["sodium"]!) + "mg"
            self.cholesterolLabel.text = " 콜레스테롤: " + String(total["cholesterol"]!) + "mg"
            self.fattyAcidLabel.text = " 포화지방: " + String(total["fattyAcid"]!) + "mg"
            self.transFatLabel.text = " 트랜스지방: " + String(total["transFat"]!) + "mg"
            
            self.piechartCenterLabel.isHidden = false
            
            
        }).disposed(by: disposeBag)
        
        
        output.minuteLabel.subscribe(onNext: { text in
            self.minuteLabel.text = "\(text)분"
            
            
        }).disposed(by: disposeBag)
        
    }
    
    // 데이터 적용하기
    func setPieData(pieChartView: PieChartView, pieChartDataEntries: [ChartDataEntry]) {
        // Entry들을 이용해 Data Set 만들기
        let pieChartdataSet = PieChartDataSet( entries: pieChartDataEntries , label: ""  )
        
        pieChartdataSet.entryLabelColor = .white
        
        pieChartdataSet.valueFont = UIFont(name: "ArialHebrew" ,size: 0)!
        pieChartdataSet.entryLabelFont = UIFont(name: "ArialHebrew" ,size: 0)!
        
        // 색상 추가
        pieChartdataSet.colors = self.ingredientsColor
        
        // DataSet을 차트 데이터로 넣기
        let pieChartData = PieChartData(dataSet: pieChartdataSet)
        // 데이터 출력
        
        pieChartView.data = pieChartData
        
        pieChartView.rotationEnabled = false
        
    }
    
    
    
    // entry 만들기
    func entryData(values: [Double] , dataPoints: [String] ) -> [ChartDataEntry] {
        // entry 담을 array
        var pieDataEntries: [ChartDataEntry] = []
        // 담기
        for i in 0 ..< values.count {
            //, label: dataPoints[i] ,data: dataPoints[i]
            let pieDataEntry = PieChartDataEntry(value: values[i] )
            pieDataEntries.append(pieDataEntry)
        }
        // 반환
        return pieDataEntries
    }
    
}
