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
    let leftBarButton : UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = "x"
        barButton.tintColor = .white
        return barButton
        
    }()
    
    let rightBarButton : UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = "이동"
        barButton.tintColor = .white
        // barButton.isEnabled = false
        return barButton
        
    }()
    
    var calendarView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30
        view.backgroundColor = UIColor(red: 0.949, green: 0.918, blue: 0.886, alpha: 1)
        return view
    }()
    
    var informationView : UIStackView = {
        let view = UIStackView(arrangedSubviews: [UILabel() , UILabel()])
        view.backgroundColor = .white.withAlphaComponent(0.5)
        view.layer.cornerRadius = 30
        view.axis = .horizontal
        view.spacing = 5
        return view
        
    }()
    
    var selectedDate: Date = Date()
    
    var selectingDate = PublishSubject<String>()

    

    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = rightBarButton
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        addView()
        setCalendarUI()
        setBindings()
        
        
        
    }
    func addView(){
//        calendarView.backgroundColor = UIColor(red: 0.09, green: 0.176, blue: 0.031, alpha: 1)
        
        self.view.addSubview(calendarView)
        self.calendarView.addSubview(calendar)
        self.calendarView.addSubview(informationView)
        
        self.informationView.translatesAutoresizingMaskIntoConstraints = false
        self.calendar.translatesAutoresizingMaskIntoConstraints = false
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor , constant: 15),
            calendarView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor , constant: -15),
            calendarView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
//
            calendar.topAnchor.constraint(equalTo: calendarView.safeAreaLayoutGuide.topAnchor),
            calendar.bottomAnchor.constraint(equalTo: calendarView.safeAreaLayoutGuide.bottomAnchor ,constant:  -150),
            calendar.widthAnchor.constraint(equalTo: calendarView.safeAreaLayoutGuide.widthAnchor ),
            
            informationView.topAnchor.constraint(equalTo: calendar.bottomAnchor),
            informationView.leadingAnchor.constraint(equalTo: calendar.leadingAnchor , constant: 10),
            informationView.trailingAnchor.constraint(equalTo: calendar.trailingAnchor , constant: -10),
            informationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor , constant: -10),
            
            
        ])
        
    }
    
    
    func setBindings(){
        
        let input = CalendarVM.Input(rightBarButtonTapped: self.rightBarButton.rx.tap.asObservable() ,
                                     selectingDate : self.selectingDate.asObservable())
        
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {return}
        
        
        
        
        
        
        
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
        self.calendar.appearance.borderDefaultColor = .brown
        
        // Header dateFormat, 년도, 월 폰트(사이즈)와 색, 가운데 정렬
        self.calendar.appearance.headerDateFormat = "YYYY. MM"
        self.calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 20)
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
        
        
        self.calendar.select(selectedDate)
    }
    
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectingDate.onNext(dateFormatter.string(from: date))
    }

    
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return UIColor.brown.withAlphaComponent(0.5)
    }
    
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return UIColor.brown
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return UIColor.white
    }
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        
        if dateFormatter.string(from: date) == dateFormatter.string(from: Date()) {
            return "오늘" }
        else{
            return nil
        }
    }
    
    
    
    
    
    
}

