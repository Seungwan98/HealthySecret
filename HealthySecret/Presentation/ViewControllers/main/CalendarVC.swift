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
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView : UIView = {
        let view = UIView()
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
    
    var selectingDate = BehaviorSubject<Date>(value : Date())
    
    let bottomView = UIView()
    
    
    private let writeButton : UIButton = {
        let button = UIButton()
        
        
        button.setTitle("일기 쓰기", for: .normal)
        button.tintColor = .white
     
        button.layer.cornerRadius = 30
        button.backgroundColor = .systemBlue.withAlphaComponent(0.8)
        return button
    }()
    private let moveButton : UIButton = {
        let button = UIButton()
        
        
        button.setTitle("날짜로 이동", for: .normal)
   
        
        button.backgroundColor = .black
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let backgroundLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray.withAlphaComponent(1)
        label.text = "작성된 일기가 없어요"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.hidesBottomBarWhenPushed = true
        navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        
        
        
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
        self.informLabel.numberOfLines = 0
        self.informLabel.sizeToFit()
        
        
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
        self.informationView.addSubview(backgroundLabel)

        
        
        self.bottomView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalTo(self.view)
            $0.height.equalTo(100)
        }
        self.contentScrollView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.bottomView.snp.top)
        } 
        self.contentView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.width.equalTo(self.contentScrollView)
        }
        self.writeButton.snp.makeConstraints{
            $0.height.equalTo(60)
            $0.width.equalTo(100)
            $0.leading.equalTo(bottomView).inset(15)
            $0.centerY.equalTo(bottomView).offset(-10)
        } 
        
        self.moveButton.snp.makeConstraints{
            $0.height.equalTo(60)
            $0.leading.equalTo(writeButton.snp.trailing).offset(15)
            $0.trailing.equalTo(bottomView).inset(15)
            $0.centerY.equalTo(bottomView).offset(-10)
       
        }
        self.calendarView.snp.makeConstraints{
            $0.leading.trailing.top.bottom.equalTo(self.contentView)
        }
        self.calendar.snp.makeConstraints{
            $0.top.equalTo(calendarView.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(calendarView.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(500)
        }
        self.informationView.snp.makeConstraints{
            $0.top.equalTo(calendar.snp.bottom)
            $0.leading.trailing.equalTo(calendar)
            $0.bottom.equalTo(informLabel)
        }
        self.backgroundLabel.snp.makeConstraints{
            $0.centerY.centerX.equalTo(informationView)
        }
        self.dateLabel.snp.makeConstraints{
            $0.top.leading.equalTo(informationView).inset(15)
            $0.width.equalTo(100)
            $0.height.equalTo(20)
        } 
        self.informLabel.snp.makeConstraints{
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(informationView).inset(15)
            $0.bottom.equalTo(contentView).offset(-15)
        }
    
        
    }
    
    
    func setBindings(){
        
        
        let input = CalendarVM.Input( viewWillApearEvent:  self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }), moveButtonTapped: moveButton.rx.tap.asObservable() , writeButtonTapped: writeButton.rx.tap.asObservable() ,
                                     selectingDate : self.selectingDate.asObservable())
        
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {return}
        
        
        
        
        
        output.outputDate.subscribe(onNext: {
            date in
            self.dateLabel.text = date
            
            
            
        }).disposed(by: disposeBag)
        
        
        output.outputTodayDiary.subscribe(onNext: { text in
            var memo = ""
            
            if text.isEmpty{
                self.backgroundLabel.isHidden = false
                self.writeButton.setTitle("일기 쓰기", for: .normal)
                memo = "\n\n\n"
                
                
                
            }else{
                self.writeButton.setTitle("일기 수정", for: .normal)

                self.backgroundLabel.isHidden = true
                
                memo = text
                
            }
            //            self.informLabel.text = memo
            
            self.informLabel.text = "\n" + memo + "\n\n"
            
            
            
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



