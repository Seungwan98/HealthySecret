//
//  DiaryVC.swift
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
import AVFoundation
import Photos
import SnapKit

class DiaryViewController: UIViewController {
    
    let viewModel: DiaryVM?
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
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    
    var pieChart: PieChartView = {
        let pieChart = PieChartView()
        
        
        pieChart.noDataText = ""
        pieChart.noDataFont = .systemFont(ofSize: 20)
        pieChart.noDataTextColor = .black
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
    lazy var nutrientsLabelsArr: [UILabel] =  [self.nutrientsLabel1, self.nutrientsLabel2, self.nutrientsLabel3]
    
    
    
    // 메인 차트뷰
    var chartView: UIView = {
        let view = UIView()
        // view.backgroundColor = UIColor.brown.withAlphaComponent(0.5)
        view.backgroundColor = .chartViewColor
        
        view.frame = CGRect(x: 0, y: 0, width: 110, height: 100)
        
        let leftLabel = UILabel()
        leftLabel.font = .systemFont(ofSize: 24, weight: .bold)
        leftLabel.text = "오늘 하루"
        leftLabel.textColor = .black
        
        view.addSubview(leftLabel)
        
        leftLabel.snp.makeConstraints {
            $0.leading.top.equalTo(view).inset(20)
        }
        
        
        
        return view
        
        
    }()
    
    
    
    
    
    lazy var buttonStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [mealButtons[0], mealButtons[1]] )
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 10
        
        return view
        
    }()
    
    lazy var buttonStackView2: UIStackView = {
        let view = UIStackView(arrangedSubviews: [mealButtons[2], mealButtons[3]] )
        //  view.backgroundColor = UIColor(red: 0.686, green: 0.776, blue: 0.627, alpha: 1)
        view.axis = .horizontal
        view.spacing = 10
        view.distribution = .fillEqually
        return view
        
    }()
    
    
    
    
    
    
    lazy var majorLabelsStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: nutrientsLabelsArr )
        view.axis = .vertical
        view.spacing = 0
        view.distribution = .fillEqually
        
        return view
    }()
    
    
    let nutrientsLabel11 = UILabel()
    let nutrientsLabel21 = UILabel()
    let nutrientsLabel31 = UILabel()
    lazy var nutrientsLabelsArr2: [UILabel] =  [self.nutrientsLabel11, self.nutrientsLabel21, self.nutrientsLabel31]
    lazy var majorLabelsStackView2: UIStackView = {
        
        let view = UIStackView(arrangedSubviews: nutrientsLabelsArr2 )
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fillEqually
        view.spacing = 0
        
        return view
        
    }()
    
    
    
    var majorImageArr = [ UIImageView(image: UIImage(named: "firstDout.png")), UIImageView(image: UIImage(named: "secondDout.png")), UIImageView(image: UIImage(named: "thirdDout.png")) ]
    
    
    lazy var majorImageStackView: UIStackView = {
        let view = UIStackView()
        
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
    
    lazy var ingredientsLabels: [UILabel] = [ kcalLabel, carbohydratesLabel, proteinLabel, provinceLabel, sugarsLabel, sodiumLabel, cholesterolLabel, fattyAcidLabel, transFatLabel ]
    
    
    lazy var ingredientsStackView: UIStackView = {
        _ = self.ingredientsLabels.map { $0.isHidden = true }
        let labels = self.ingredientsLabels.map({ (label: UILabel ) -> UILabel in
            label.font = UIFont.systemFont(ofSize: 12)
            return label
        })
        let view = UIStackView(arrangedSubviews: labels)
        
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
    
    lazy var mealBottomImages = [breakFastBottomImage, lunchBottomImage, dinnerBottomImage, snackBottomImage]
    
    lazy var mealButtonViews = [breakfastButtonView, lunchButtonView, dinnerButtonView, snackButtonView]
    
    lazy var breakfastButtonView: UIView = {
        
        let buttonView = UIView()
        let backgroundImageView = UIImageView()
        let bottomImageView = UIImageView()
        let label = UILabel()
        
        backgroundImageView.image = UIImage(named: "breakfast.png")
        
        
        label.text = "아침"
        label.font = .systemFont(ofSize: 20)
        
        buttonView.addSubview(backgroundImageView)
        buttonView.addSubview(label)
        
        
        label.snp.makeConstraints {
            $0.top.leading.equalTo(buttonView).inset(20)
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.width.height.equalTo(buttonView)
        }
        
        
        return buttonView
    }()
    lazy var lunchButtonView: UIView = {
        let buttonView = UIView()
        let backgroundImageView = UIImageView()
        let bottomImageView = UIImageView()
        let label = UILabel()
        
        backgroundImageView.image = UIImage(named: "lunch.png")
        
        
        label.text = "점심"
        label.font = .systemFont(ofSize: 20)
        
        
        
        buttonView.addSubview(backgroundImageView)
        buttonView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.top.leading.equalTo(buttonView).inset(20)
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.width.height.equalTo(buttonView)
        }
        return buttonView
        
    }()
    lazy var dinnerButtonView: UIView = {
        let buttonView = UIView()
        let backgroundImageView = UIImageView()
        let bottomImageView = UIImageView()
        let label = UILabel()
        
        backgroundImageView.image = UIImage(named: "dinner.png")
        
        
        label.text = "저녁"
        label.font = .systemFont(ofSize: 20)
        
        
        
        buttonView.addSubview(backgroundImageView)
        buttonView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.top.leading.equalTo(buttonView).inset(20)
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.width.height.equalTo(buttonView)
        }
        
        return buttonView
        
    }()
    
    lazy var snackButtonView: UIView = {
        
        let buttonView = UIView()
        let backgroundImageView = UIImageView()
        let bottomImageView = UIImageView()
        let label = UILabel()
        
        backgroundImageView.image = UIImage(named: "snack.png")
        
        
        label.text = "간식"
        label.font = .systemFont(ofSize: 20)
        
        
        
        
        buttonView.addSubview(backgroundImageView)
        buttonView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.top.leading.equalTo(buttonView).inset(20)
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.width.height.equalTo(buttonView)
        }
        
        
        
        return buttonView
    }()
    
    
    
    var breakfastLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    var lunchLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        
        
        return label
    }()
    var dinnerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        
        return label
    }()
    
    var snackLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    
    lazy var mealButtons = [breakfastButton, lunchButton, dinnerButton, snackButton]
    
    var breakfastButton = UIButton()
    var lunchButton = UIButton()
    var dinnerButton = UIButton()
    var snackButton = UIButton()
    
    
    
    
    
    
    var detailButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .chartLightColor
        
        button.setTitle("상세정보", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        return button
        
    }()
    
    
    
    var majorView = UIView()
    var bottomView = UIView()
    
    lazy var calendarLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        
        return label
        
    }()
    
    
    
    var ingredientsLabelArr: [UILabel] = []
    
    
    var ingredientsName: [String] = [  "탄수화물", "단백질", "지방" ]
    
    var ingredientsPercent: [Double] = [0.0, 0.0, 0.0]
    
    var ingredientsColor: [UIColor] = [ .carbohydrates, .protein, .province  ]
    
    
    
    var rightBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: DiaryViewController.self, action: nil)
        barButton.tintColor = .black
        
        return barButton
        
        
        
    }()
    
    
    
    var leftBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: DiaryViewController.self, action: nil)
        barButton.tintColor = .black
        return barButton
        
    }()
    
    
    var exerciseButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.layer.cornerRadius = 30
        return button
        
    }()
    
    var leftCalorieLabel = UILabel()
    var goalLabel = UILabel()
    var eatLabel = UILabel()
    var consumeLabel = UILabel()
    let informLabel1 = UILabel()
    let informLabel2 = UILabel()
    let informLabel3 = UILabel()
    lazy var informLabelArr = [informLabel1, informLabel2, informLabel3]
    lazy var informDataArr = [goalLabel, eatLabel, consumeLabel]
    lazy var informationView: UIView = {
        let view = UIView()
        
        let stackView = UIStackView(arrangedSubviews: informLabelArr )
        
        view.addSubview(stackView)
        view.addSubview(self.leftCalorieLabel)
        
        self.leftCalorieLabel.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(view).inset(10)
        }
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view).inset(50)
            $0.height.equalTo(20)
            $0.bottom.equalTo(view).inset(10)
        }
        
        
        
        leftCalorieLabel.font = .systemFont(ofSize: 16)
        leftCalorieLabel.textColor = .black
        leftCalorieLabel.text = "120kcal 초과됐습니다"
        
        
        
        
        
        
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.distribution = .equalCentering
        
        
        
        
        view.layer.cornerRadius = 8
        
        view.backgroundColor = .chartLightColor
        
        
        return view
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setBinds()
        
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    let buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = .mealGreen
        
        let leftLabel = UILabel()
        leftLabel.font = .systemFont(ofSize: 24, weight: .bold)
        leftLabel.text = "나의 식사"
        leftLabel.textColor = .black
        view.addSubview(leftLabel)
        
        leftLabel.snp.makeConstraints {
            $0.leading.top.equalTo(view).inset(20)
        }
        
        
        
        return view
        
        
        
    }()
    
    var minuteLabel = UILabel()
    var exCalorieLabel = UILabel()
    lazy var exerciseView: UIView = {
        let image = UIImageView(image: UIImage(named: "ic_health.png"))
        let view = UIView()
        let centerLabel = UILabel()
        
        
        let leftLabel = UILabel()
        
        centerLabel.font = .systemFont(ofSize: 18)
        centerLabel.text = "오늘 활동 시간은?"
        centerLabel.textColor = .black
        
        
        
        self.minuteLabel.font = .systemFont(ofSize: 40)
        self.minuteLabel.text = "분"
        self.minuteLabel.textColor = .black
        
        self.exCalorieLabel.font = .systemFont(ofSize: 20)
        self.exCalorieLabel.text = ""
        self.exCalorieLabel.textColor = .black
        
        
        
        
        leftLabel.font = .systemFont(ofSize: 24, weight: .bold )
        leftLabel.text = "나의 활동"
        leftLabel.textColor = .black
        
        
        
        
        view.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        
        
        self.exerciseButton.backgroundColor = view.backgroundColor?.withAlphaComponent(0.2)
        
        
        view.addSubview(image)
        view.addSubview(leftLabel)
        view.addSubview(centerLabel)
        view.addSubview(self.minuteLabel)
        view.addSubview(self.exerciseButton)
        view.addSubview(self.exCalorieLabel)
        
        centerLabel.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(self.minuteLabel.snp.top).offset(-16)
        }
        self.minuteLabel.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(image.snp.top).offset(-30)
        }
        image.snp.makeConstraints {
            $0.center.equalTo(view)
            $0.height.width.equalTo(180)
        }
        leftLabel.snp.makeConstraints {
            $0.leading.top.equalTo(view).inset(20)
        }
        self.exCalorieLabel.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(image.snp.bottom).offset(30)
        }
        self.exerciseButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leading.trailing.bottom.equalTo(view).inset(60)
        }
        
        
        
        
        return view
    }()
    
    
    
    
    
    var piechartCenterLabel: UILabel = {
        let label = UILabel()
        
        label.text = "kcal"
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .black
        label.isHidden = true
        return label
    }()
    
    var morningCheckImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "check.png"))
        imageView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        return imageView
        
    }()
    
    
    
    
    
    
    
    
    
    func setButtons() {
        
        for i in 0..<4 {
            let view = mealButtonViews[i]
            let image = mealBottomImages[i]
            
            
            view.addSubview(image)
            view.isUserInteractionEnabled = false
            view.isExclusiveTouch = false
            
            mealButtons[i].addSubview(view)
            
            image.snp.makeConstraints {
                $0.bottom.trailing.equalTo(view).inset(10)
                $0.height.width.equalTo(22)
            }
            
            
            view.snp.makeConstraints {
                $0.height.width.equalTo(mealButtons[i])
            }
            
            
            
            
            
        }
        
        
        
        
    }
    
    
    func setUI() {
        self.navigationItem.titleView = calendarLabel
        self.view.backgroundColor = .white
        
        
        self.view.addSubview(contentScrollView)
        
        
        self.contentScrollView.addSubview(contentView)
        
        
        
        self.contentView.addSubview(chartView)
        self.chartView.addSubview(pieChart)
        self.chartView.addSubview(bottomView)
        self.bottomView.addSubview(majorView)
        self.bottomView.addSubview(informationView)
        
        
        
        self.contentView.addSubview(buttonView)
        self.contentView.addSubview(exerciseView)
        self.contentView.addSubview(detailButton)
        self.contentView.addSubview(ingredientsStackView)
        
        self.buttonView.addSubview(buttonStackView)
        self.buttonView.addSubview(buttonStackView2)
        
        
        
        self.majorView.addSubview(majorLabelsStackView)
        self.majorView.addSubview(majorLabelsStackView2)
        self.majorView.addSubview(majorImageStackView)
        self.majorView.addSubview(piechartCenterLabel)
        
        setButtons()
        
        
        
        
        let imgArr = [UIImage(named: "firstDout"), UIImage(named: "secondDout"), UIImage(named: "thirdDout")]
        let attributedString =  [NSMutableAttributedString(string: ""), NSMutableAttributedString(string: ""), NSMutableAttributedString(string: "")]
        let imageAttachment = [ NSTextAttachment(), NSTextAttachment(), NSTextAttachment()]
        
        
        let text = ["내 목표", "섭취량", "소모량"]
        for i in 0..<3 {
            informLabelArr[i].text = text[i]
            informLabelArr[i].textColor = .black
            informLabelArr[i].font = .systemFont(ofSize: 16)
            
            
            view.addSubview(informDataArr[i])
            informDataArr[i].font = .systemFont(ofSize: 26)
            informDataArr[i].textColor = .black
            informDataArr[i].text = "1200"
            
            
            informDataArr[i].snp.makeConstraints {
                $0.centerX.equalTo(informLabelArr[i])
                $0.centerY.equalTo(informationView)
            }
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        for i in 0 ..< 3 {
            imageAttachment[i].image = imgArr[i]
            imageAttachment[i].bounds = CGRect(x: 0, y: 0, width: 12, height: 12)
            
            
            attributedString[i].append(NSAttributedString(attachment: imageAttachment[i]))
            attributedString[i].append(NSAttributedString(string: "  \(ingredientsName[i])"))
            
            nutrientsLabelsArr[i].attributedText = attributedString[i]
            
            
            
            nutrientsLabelsArr[i].font =  UIFont.systemFont(ofSize: 18)
            nutrientsLabelsArr2[i].font =  UIFont.systemFont(ofSize: 18)
            nutrientsLabelsArr[i].textColor = .black
            nutrientsLabelsArr2[i].textColor = .black
            
            
            
        }
        
        
        
        self.contentScrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.contentView.snp.makeConstraints {
            $0.top.leading.trailing.width.bottom.equalTo(self.contentScrollView)
        }
        self.piechartCenterLabel.snp.makeConstraints {
            $0.centerX.equalTo(pieChart)
            $0.centerY.equalTo(pieChart).offset(14)
        }
        self.majorLabelsStackView.snp.makeConstraints {
            $0.top.bottom.equalTo(majorView)
            $0.trailing.equalTo(majorView.snp.centerX).offset(-20)
        }
        self.majorLabelsStackView2.snp.makeConstraints {
            $0.top.bottom.equalTo(majorView)
            $0.leading.equalTo(majorView.snp.centerX).offset(20)
        }
        self.chartView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(contentView)
            $0.height.equalTo(contentScrollView).offset(20)
        }
        self.detailButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(informationView)
            $0.height.equalTo(40)
            $0.bottom.equalTo(chartView).inset(20)
        }
        self.ingredientsStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.view)
            $0.height.equalTo(400)
            $0.top.equalTo(chartView.snp.bottom)
        }
        self.pieChart.snp.makeConstraints {
            $0.centerX.equalTo(chartView)
            $0.top.equalTo(chartView).inset(40)
            $0.width.equalTo(360)
            $0.bottom.equalTo(self.chartView.snp.centerY)
        }
        self.bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(self.chartView)
            $0.top.equalTo(self.pieChart.snp.bottom)
        }
        self.majorView.snp.makeConstraints {
            $0.centerX.equalTo(self.chartView.snp.centerX)
            $0.top.equalTo(self.bottomView)
            $0.bottom.equalTo(self.bottomView.snp.centerY).offset(-40)
            $0.leading.trailing.equalTo(self.view).inset(20)
        }
        self.informationView.snp.makeConstraints {
            $0.top.equalTo(self.majorView.snp.bottom).offset(16)
            $0.bottom.equalTo(self.detailButton.snp.top).offset(-16)
            
            $0.leading.trailing.equalTo(self.chartView).inset(30)
        }
        
        self.buttonStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.buttonView.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(170)
            $0.bottom.equalTo(self.buttonView.snp.centerY).offset(-5)
            
        }
        
        self.buttonStackView2.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.buttonView.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(170)
            $0.top.equalTo(self.buttonView.snp.centerY).offset(5)
            
        }
        self.buttonView.snp.makeConstraints {
            $0.top.equalTo(self.chartView.snp.bottom)
            $0.leading.trailing.equalTo(self.contentView.safeAreaLayoutGuide)
            $0.height.equalTo(contentScrollView).offset(-50)
        }
        
        self.exerciseView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.contentView.safeAreaLayoutGuide)
            $0.top.equalTo(buttonView.snp.bottom)
            $0.height.equalTo(self.contentScrollView)
            $0.bottom.equalTo(self.contentView)
        }
        
        
        
        
        
        
    }
    
    
    
    func setBinds() {
        
        let breakfast = breakfastButton.rx.tap.map { _ in return UserDefaults.standard.set("아침식사", forKey: "meal")}
        let lunch = lunchButton.rx.tap.map {  _ in return UserDefaults.standard.set("점심식사", forKey: "meal")}
        let dinner = dinnerButton.rx.tap.map {  _ in return UserDefaults.standard.set("저녁식사", forKey: "meal")}
        let snack = snackButton.rx.tap.map {  _ in return UserDefaults.standard.set("간식", forKey: "meal")}
        let leftEvent = self.leftBarButton.rx.tap.map {_ in return UserDefaults.standard.set({
            let calendar = Calendar.current
            
            let formattedDate = CustomFormatter().StringToDate(date: UserDefaults.standard.string(forKey: "date") ?? "")
            
            let yesterday = CustomFormatter().DateToString(date: calendar.date(byAdding: .day, value: -1, to: formattedDate)!)
            return yesterday
        }(), forKey: "date"
                                                                                             
                                                                                             
        )}
        
        let rightEvent = self.rightBarButton.rx.tap.map {_ in return UserDefaults.standard.set({
            let calendar = Calendar.current
            
            let formattedDate = CustomFormatter().StringToDate(date: UserDefaults.standard.string(forKey: "date") ?? "")
            
            let tomorrow = CustomFormatter().DateToString(date: calendar.date(byAdding: .day, value: +1, to: formattedDate)!)
            return tomorrow
        }(), forKey: "date"
                                                                                               
                                                                                               
        )}
        
        
        let willAppear = self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in })
        
        
        
        let tags = Observable.of(breakfast, lunch, dinner, snack).merge()
        let willAppearTags = Observable.of(leftEvent, willAppear, rightEvent ).merge()
        
        
        let input = DiaryVM.Input( viewWillApearEvent: willAppearTags, mealButtonsTapped: tags.asObservable(), calendarLabelTapped: calendarLabel.rx.tapGesture(), execiseButtonTapped: self.exerciseButton.rx.tap.asObservable(), rightBarButtonTapped: self.rightBarButton.rx.tap.asObservable(), leftBarButtonTapped: self.leftBarButton.rx.tap.asObservable(), detailButtonTapped: self.detailButton.rx.tap.asObservable())
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {return}
        
        
        
        
        output.date.subscribe(onNext: { date in
            
            self.calendarLabel.attributedText = date
            
        }).disposed(by: disposeBag)
        
        output.checkBreakFast.asDriver().drive(onNext: { [weak self] valid in
            print("breakfast")
            if valid {
                
                self?.breakFastBottomImage.image = UIImage(named: "check.png")
            } else {
                self?.breakFastBottomImage.image = UIImage(named: "add.png")
                
            }
            
        }).disposed(by: disposeBag)
        
        output.checkLunch.asDriver().drive(onNext: { [weak self] valid in
            print("lunch")
            
            if valid {
                
                self?.lunchBottomImage.image = UIImage(named: "check.png")
            } else {
                self?.lunchBottomImage.image = UIImage(named: "add.png")
                
            }
            
        }).disposed(by: disposeBag)
        
        output.checkDinner.asDriver().drive(onNext: { [weak self] valid in
            print("dinner")
            
            if valid {
                
                self?.dinnerBottomImage.image = UIImage(named: "check.png")
            } else {
                self?.dinnerBottomImage.image = UIImage(named: "add.png")
                
            }
            
        }).disposed(by: disposeBag)
        
        output.checkSnack.asDriver().drive(onNext: { [weak self] valid in
            print("snack")
            
            if valid {
                
                self?.snackBottomImage.image = UIImage(named: "check.png")
            } else {
                self?.snackBottomImage.image = UIImage(named: "add.png")
                
            }
            
        }).disposed(by: disposeBag)
        
        
        
        output.totalIngredients.subscribe(onNext: { total in
            
            
            let totalValues = (total.carbohydrates * 4) + (total.protein * 4) + (total.province * 9)
            
            
            
            if totalValues != 0.0 {
                
                let carbohydratesPer = total.carbohydrates  * 4 / totalValues * 100
                let proteinPer =  total.protein  * 4 / totalValues * 100
                let provincePer =  total.province  * 9 / totalValues * 100
                
                self.ingredientsPercent[0] = (carbohydratesPer)
                self.ingredientsPercent[1] = (proteinPer)
                self.ingredientsPercent[2] = (provincePer)
                
                self.ingredientsColor = [ .carbohydrates, .protein, .province ]
                
                
                
                self.setPieData(pieChartView: self.pieChart, pieChartDataEntries: self.entryData(values: self.ingredientsPercent, dataPoints: []))
            } else {
                
                
                self.ingredientsPercent = self.ingredientsPercent.map({ $0 * 0 })
                
                
                self.ingredientsColor = [.white.withAlphaComponent(0.6)]
                self.setPieData(pieChartView: self.pieChart, pieChartDataEntries: self.entryData(values: [1], dataPoints: []))
            }
            
            
            
            
            
            
            
            
            
            
            
            for i in 0..<self.ingredientsPercent.count {
                self.nutrientsLabelsArr2[i].text = (String(format: "%.2f", self.ingredientsPercent[i]) + "%" )
                
                
            }
            
            
            
            
            
            
            
            
            self.carbohydratesLabel.text = " 탄수화물: " + String(total.carbohydrates) + "g"
            self.proteinLabel.text = " 단백질: " + String(total.protein) + "g"
            self.provinceLabel.text = " 지방: " + String(total.province) + "g"
            self.sugarsLabel.text = " 당류: " + String(total.sugars) + "g"
            self.sodiumLabel.text = " 나트륨: " + String(total.sodium) + "mg"
            self.cholesterolLabel.text = " 콜레스테롤: " + String(total.cholesterol) + "mg"
            self.fattyAcidLabel.text = " 포화지방: " + String(total.fattyAcid) + "mg"
            self.transFatLabel.text = " 트랜스지방: " + String(total.transFat) + "mg"
            
            self.piechartCenterLabel.isHidden = false
            
            
        }).disposed(by: disposeBag)
        
        
        output.minuteLabel.subscribe(onNext: { text in
            self.minuteLabel.text = "\(text)분"
            if text == "0" {
                self.exerciseButton.setTitle("기록하기", for: .normal)
            } else {
                self.exerciseButton.setTitle("수정하기", for: .normal)
                
                
            }
        }).disposed(by: disposeBag)
        
        
        
        
        
        
        
        let a = output.goalLabel
        let b = output.ingTotalCalorie
        let c = output.exCalorieLabel
        
        
        Observable.combineLatest( a, b, c ).subscribe(onNext: { [weak self] in guard let self = self else {return}
            
            
            
            self.goalLabel.text = $0
            
            self.exCalorieLabel.text = "소모량  \($2)kcal"
            
            self.consumeLabel.text = $2
            
            
            
            let leftCalorie = (Int( $0 ) ?? 0) - (Int($1) ?? 0) + (Int($2) ?? 0)
            
            
            
            if leftCalorie > 0 {
                self.leftCalorieLabel.text = ("\(leftCalorie)kcal 더 먹을 수 있어요")
                
            } else {
                self.leftCalorieLabel.text = ("\(-leftCalorie)kcal 초과됐어요")
                
            }
            
            
            
            let attrString = NSAttributedString(string: $1 + "\n", attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22), .foregroundColor: UIColor.black as Any ])
            
            
            self.eatLabel.text = $1
            self.pieChart.centerAttributedText = attrString
            
            self.kcalLabel.text = " 칼로리: " + $1 + "kcal"
            
            
            
        }).disposed(by: disposeBag)
        
        output.alert.subscribe(onNext: { text in
            
            AlertHelper.shared.showResult(title: "알림", message: text, over: self)
            
        }).disposed(by: disposeBag)
        
        
    }
    
    // 데이터 적용하기
    func setPieData(pieChartView: PieChartView, pieChartDataEntries: [ChartDataEntry]) {
        // Entry들을 이용해 Data Set 만들기
        let pieChartdataSet = PieChartDataSet( entries: pieChartDataEntries, label: ""  )
        
        pieChartdataSet.entryLabelColor = .white
        
        pieChartdataSet.valueFont = UIFont(name: "ArialHebrew", size: 0)!
        pieChartdataSet.entryLabelFont = UIFont(name: "ArialHebrew", size: 0)!
        
        // 색상 추가
        pieChartdataSet.colors = self.ingredientsColor
        
        // DataSet을 차트 데이터로 넣기
        let pieChartData = PieChartData(dataSet: pieChartdataSet)
        // 데이터 출력
        
        pieChartView.data = pieChartData
        
        pieChartView.rotationEnabled = false
        
    }
    
    
    
    // entry 만들기
    func entryData(values: [Double], dataPoints: [String] ) -> [ChartDataEntry] {
        // entry 담을 array
        var pieDataEntries: [ChartDataEntry] = []
        // 담기
        for i in 0..<values.count {
            let pieDataEntry = PieChartDataEntry(value: values[i] )
            pieDataEntries.append(pieDataEntry)
        }
        // 반환
        return pieDataEntries
    }
}
