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
    
    var CalendarView = UIView()
    
    
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
        CalendarView.backgroundColor = UIColor(red: 0.09, green: 0.176, blue: 0.031, alpha: 1)
        
        self.view.addSubview(CalendarView)
        self.CalendarView.addSubview(calendar)
        
        self.calendar.translatesAutoresizingMaskIntoConstraints = false
        self.CalendarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            CalendarView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            CalendarView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            CalendarView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor),
            CalendarView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor),
            calendar.centerXAnchor.constraint(equalTo: CalendarView.safeAreaLayoutGuide.centerXAnchor),
            calendar.centerYAnchor.constraint(equalTo: CalendarView.safeAreaLayoutGuide.centerYAnchor),
            calendar.widthAnchor.constraint(equalTo: CalendarView.safeAreaLayoutGuide.widthAnchor),
            calendar.heightAnchor.constraint(equalTo: CalendarView.safeAreaLayoutGuide.heightAnchor),
            
            
            
            
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
        
        self.calendar.backgroundColor = UIColor(red: 0.949, green: 0.918, blue: 0.886, alpha: 1)
        
        
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
        
        // 캘린더의 cornerRadius 지정
        self.calendar.layer.cornerRadius = 50
        
        
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

