//
//  CalendarViewController.swift
//  HealthySecret
//
//  Created by 양승완 on 2024/01/11.
//

import Foundation
import UIKit
import FSCalendar
import RxSwift

class CalendarViewController : UIViewController , FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    let viewModel : CalendarVM?
    let disposeBag = DisposeBag()
    init(viewModel: CalendarVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    var calendar = FSCalendar()
    
    var dateFormatter = DateFormatter()
  
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
    
    
    var calendarView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let dateLabel = UILabel()
    let informLabel = UILabel()
    
    
    let informationView : UIView = {
        let view = UIView()
        
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        view.layer.cornerRadius = 20
        return view
        
    }()
    
    var selectedDate: Date = Date()
    
    var selectingDate = PublishSubject<Date>()

    let bottomView = UIView()
    
    
    private let writeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.setTitle("메모 작성", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 30
        button.backgroundColor = .systemBlue.withAlphaComponent(0.8)
        return button
    }()
    private let moveButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.setTitle("날짜로 이동", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)

        button.backgroundColor = .black
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let dynamicView = UIView()

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        addView()
        setCalendarUI()
        setBindings()
        
       
        
        
    }
    func addView(){
//        calendarView.backgroundColor = UIColor(red: 0.09, green: 0.176, blue: 0.031, alpha: 1)
        self.dateLabel.font = .boldSystemFont(ofSize: 14)
        self.informLabel.font = .boldSystemFont(ofSize: 14)
        self.informLabel.sizeToFit()
        self.informLabel.numberOfLines = 0
       
        self.informationView.sizeToFit()

        
        
        
        self.view.addSubview(contentScrollView)
        self.view.addSubview(bottomView)
        
        self.bottomView.addSubview(writeButton)
        self.bottomView.addSubview(moveButton)

        self.contentScrollView.addSubview(contentView)
        
        self.contentView.addSubview(calendarView)
        self.calendarView.addSubview(calendar)
        self.calendarView.addSubview(informationView)
        self.informationView.addSubview(dateLabel)
        self.informationView.addSubview(informLabel)
        
        

        
        self.bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.informationView.translatesAutoresizingMaskIntoConstraints = false
        self.calendar.translatesAutoresizingMaskIntoConstraints = false
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        self.writeButton.translatesAutoresizingMaskIntoConstraints = false
        self.moveButton.translatesAutoresizingMaskIntoConstraints = false
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.informLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 100),
            
            self.contentScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor ),
            self.contentScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.contentScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.contentScrollView.bottomAnchor.constraint(equalTo: self.bottomView.topAnchor),
            
            self.contentView.topAnchor.constraint(equalTo: self.contentScrollView.topAnchor ),
            self.contentView.leadingAnchor.constraint(equalTo: self.contentScrollView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.contentScrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.contentScrollView.bottomAnchor),
            
            self.contentView.widthAnchor.constraint(equalTo: self.contentScrollView.widthAnchor , multiplier: 1.0),
            
            




            writeButton.heightAnchor.constraint(equalToConstant: 60),
            writeButton.widthAnchor.constraint(equalToConstant: 100),
            writeButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor , constant: 15),
            writeButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor , constant: -10 ),



            moveButton.heightAnchor.constraint(equalToConstant: 60),
            moveButton.leadingAnchor.constraint(equalTo: writeButton.trailingAnchor, constant: 15),
            moveButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -15),
            moveButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor , constant: -10 ),

            
            calendarView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor , constant: 0),
            calendarView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor , constant: -0),
            calendarView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor),
            
//
            calendar.topAnchor.constraint(equalTo: calendarView.safeAreaLayoutGuide.topAnchor),
            calendar.heightAnchor.constraint(equalToConstant:  600),
            calendar.leadingAnchor.constraint(equalTo: calendarView.safeAreaLayoutGuide.leadingAnchor  , constant: 10),
            calendar.trailingAnchor.constraint(equalTo: calendarView.safeAreaLayoutGuide.trailingAnchor , constant: -10 ),
            
            informationView.topAnchor.constraint(equalTo: calendar.bottomAnchor),
            informationView.leadingAnchor.constraint(equalTo: calendar.leadingAnchor , constant: 0),
            informationView.trailingAnchor.constraint(equalTo: calendar.trailingAnchor , constant: 0 ),
            informationView.heightAnchor.constraint(equalTo: informLabel.heightAnchor , constant: 50 ),
            
            informationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

//
//
            dateLabel.topAnchor.constraint(equalTo: informationView.topAnchor , constant: 15),
            dateLabel.leadingAnchor.constraint(equalTo: informationView.leadingAnchor , constant: 15),
            dateLabel.widthAnchor.constraint(equalToConstant: 100),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),

            informLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor , constant: 10 ),
            informLabel.leadingAnchor.constraint(equalTo: informationView.leadingAnchor , constant: 15),
            informLabel.trailingAnchor.constraint(equalTo: informationView.trailingAnchor , constant: -15),

            
        ])
        
    }
    
    
    func setBindings(){
        
        
        let input = CalendarVM.Input(moveButtonTapped: moveButton.rx.tap.asObservable() ,
                                     selectingDate : self.selectingDate.asObservable())
        
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {return}
        
   
        
        self.selectingDate.onNext(self.selectedDate)
        
        
        output.outputDate.subscribe(onNext: {
            date in
            self.dateLabel.text = date
            
            
            
        }).disposed(by: disposeBag)
        
        
        output.outputTodayMemo.subscribe(onNext: { text in
            var memo = ""
            if text.isEmpty{
              memo = "\n\n\n\n"


            }else{
              
                memo = text

            }
            self.informLabel.text = memo

            
            
            
        }).disposed(by: disposeBag)
        
        
        
    }
    
    
    
    func setCalendarUI() {
        // delegate, dataSource
        self.calendar.delegate = self
        self.calendar.dataSource = self
        
        self.calendar.backgroundColor = .clear
        
        
        // calendar locale > 한국으로 설정
        self.calendar.locale = Locale(identifier: "ko_KR")
        
        // 상단 요일을 한글로 변경
        self.calendar.calendarWeekdayView.weekdayLabels[0].text = "일"
        self.calendar.calendarWeekdayView.weekdayLabels[1].text = "월"
        self.calendar.calendarWeekdayView.weekdayLabels[2].text = "화"
        self.calendar.calendarWeekdayView.weekdayLabels[3].text = "수"
        self.calendar.calendarWeekdayView.weekdayLabels[4].text = "목"
        self.calendar.calendarWeekdayView.weekdayLabels[5].text = "금"
        self.calendar.calendarWeekdayView.weekdayLabels[6].text = "토"
        
        
        
        
        
        self.calendar.appearance.headerTitleOffset = .init(x: -135, y: 0)
        
        // 월~일 글자 폰트 및 사이즈 지정
        self.calendar.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 14)
        // 숫자들 글자 폰트 및 사이즈 지정
        self.calendar.appearance.titleFont = UIFont.boldSystemFont(ofSize: 14)
        
        
        // 캘린더 스크롤 가능하게 지정
        self.calendar.scrollEnabled = true
        // 캘린더 스크롤 방향 지정
        self.calendar.scrollDirection = .horizontal
        self.calendar.appearance.borderDefaultColor = .clear
        
        // Header dateFormat, 년도, 월 폰트(사이즈)와 색, 가운데 정렬
        self.calendar.appearance.headerDateFormat = "YYYY. MM"
        self.calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 24)
        self.calendar.appearance.headerTitleColor = UIColor.black
        // 요일 글자 색
        self.calendar.appearance.weekdayTextColor = UIColor.black
        
        // 캘린더 높이 지정
        self.calendar.headerHeight = 68
        
       
        
        
        // 양옆 년도, 월 지우기
        self.calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
        // 달에 유효하지 않은 날짜의 색 지정
        self.calendar.appearance.titlePlaceholderColor = UIColor.black
        // 평일 날짜 색
        self.calendar.appearance.titleDefaultColor = UIColor.black
        
        // 달에 유효하지않은 날짜 지우기
        self.calendar.placeholderType = .none
        
        // 캘린더 숫자와 subtitle간의 간격 조정
        self.calendar.appearance.subtitleOffset = CGPoint(x: 0, y: 4)
        
        self.calendar.appearance.eventSelectionColor = .systemGreen
        
        
        self.calendar.select(selectedDate)
        
    
    }
    
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectingDate.onNext(date)
    }

    
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return UIColor.lightGray.withAlphaComponent(0.2)
    }
    
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return UIColor.systemGreen
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return UIColor.white
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return UIColor.black
    }

    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
       
        if dateFormatter.string(from: date) == dateFormatter.string(from: Date()) {
     
           
            return "오늘" }
        else{
            return nil
        }
    }
    
    
    
    
    
    
}


extension UIScrollView {
   func updateContentView() {
      contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
   }
}
