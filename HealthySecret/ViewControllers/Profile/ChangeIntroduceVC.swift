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
import Kingfisher
import AVFoundation
import Photos

class ChangeIntroduceVC : UIViewController {
    
    var cnt = 0
    
    let disposeBag = DisposeBag()

    private var viewModel : ChangeIntroduceVM?
    
    let imagePicker = UIImagePickerController()

    
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
    
    
    private let profileImageView : UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 50
        view.layer.masksToBounds = true

        view.tintColor = .white

      
        return view
        
    }()
    
    private let maxCount = 50
       private var textCount = 0 {
           didSet { self.writeContentLabel.text = "\(textCount)/\(maxCount)" }
       }
    
    
    
    private let nameTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .lightGray.withAlphaComponent(0.2)
        textField.layer.cornerRadius = 10
        textField.tintColor = .black
        textField.font = .boldSystemFont(ofSize: 18)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 4.5, height: textField.frame.height))
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 4.5, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightViewMode = .always

        return textField
    }()

    
    lazy var introduceTextView : UITextView = {
        // Create a TextView.
        let textView: UITextView = UITextView()

        textView.translatesAutoresizingMaskIntoConstraints = false

        textView.backgroundColor = .lightGray.withAlphaComponent(0.2)

        textView.layer.cornerRadius = 10

        textView.textAlignment = .left
        
        textView.font = UIFont.boldSystemFont(ofSize: 18)

        textView.textColor = UIColor.black

        textView.textAlignment = NSTextAlignment.left

        textView.dataDetectorTypes = UIDataDetectorTypes.all
  
        textView.isEditable = true

        textView.textColor = .black
        
        textView.tintColor = .black
       
        textView.delegate = self
        
        return textView
    }()
    
    lazy var writeContentLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "0/\(self.maxCount)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
        
    }()

    
    private let firstView = UIView()
    
    let bottomView : UIView = {
       let view = UIView()
       
       
       view.translatesAutoresizingMaskIntoConstraints = false
     
       return view
   }()
    
    private let addButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .black
        
        button.setTitle("수정하기", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        return button
    }()
    
    
    
    init(viewModel : ChangeIntroduceVM  ){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.topItem?.title = "프로필 수정"
        self.setupKeyboardEvent()
        

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    var imageOutput = BehaviorSubject<UIImage?>(value: nil)
    var imageChanging = BehaviorSubject<Bool>(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

        
        setUI()
        setBindings()
        
        
    }
    
    
    
    
    var BOTTOMVIEW_ORIGIN_Y : CGFloat?

    let labels = [UILabel() , UILabel()]
    
    let text = ["닉네임" , "내 소개"]
    
    let topImage = UIImageView(image:UIImage(named: "camera.png"))
    let smileImage = UIImage(named: "일반적.png")

   
  
    func setUI(){
        
        topImage.translatesAutoresizingMaskIntoConstraints = false
        topImage.isHidden = true
        
        self.view.addSubview(contentScrollView)
        self.view.addSubview(bottomView)
        
        self.contentScrollView.addSubview(contentView)
        
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(topImage)
        self.contentView.addSubview(firstView)
        
        
        firstView.addSubview(nameTextField)
        firstView.addSubview(introduceTextView)
        firstView.addSubview(writeContentLabel)
        firstView.translatesAutoresizingMaskIntoConstraints = false
        
        
            
        for i in 0..<labels.count{
            firstView.addSubview(labels[i])

            labels[i].translatesAutoresizingMaskIntoConstraints = false
            labels[i].text = text[i]
            labels[i].font = .boldSystemFont(ofSize: 16)
            labels[i].textColor = .lightGray.withAlphaComponent(0.8)
            

            
        }
       
        
        bottomView.addSubview(addButton)
        

            
          
        
        
        
        NSLayoutConstraint.activate([
            
            topImage.widthAnchor.constraint(equalToConstant: 30),
            topImage.heightAnchor.constraint(equalToConstant: 30) ,
            topImage.trailingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor),
            topImage.bottomAnchor.constraint(equalTo: self.profileImageView.bottomAnchor),
            
            
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
            self.contentView.widthAnchor.constraint(equalTo: self.contentScrollView.widthAnchor , multiplier: 1.0),
            
   

            
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            profileImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor ),
            profileImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor , constant: 40 ),
            
            firstView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor , constant: 70),
            firstView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 20),
            firstView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -20),
            firstView.heightAnchor.constraint(equalToConstant: 450),
            self.firstView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
           
            labels[0].topAnchor.constraint(equalTo: firstView.topAnchor ),
            labels[0].leadingAnchor.constraint(equalTo: firstView.leadingAnchor),

            nameTextField.topAnchor.constraint(equalTo: labels[0].bottomAnchor , constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo:firstView.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: firstView.trailingAnchor ),
            nameTextField.heightAnchor.constraint(equalToConstant: 60 ),
            
            labels[1].topAnchor.constraint(equalTo: nameTextField.bottomAnchor , constant: 20),
            labels[1].leadingAnchor.constraint(equalTo: firstView.leadingAnchor),
            
            introduceTextView.topAnchor.constraint(equalTo: labels[1].bottomAnchor , constant: 10),
            introduceTextView.leadingAnchor.constraint(equalTo:firstView.leadingAnchor),
            introduceTextView.trailingAnchor.constraint(equalTo: firstView.trailingAnchor ),
            introduceTextView.heightAnchor.constraint(equalToConstant: 260 ),
            
            writeContentLabel.trailingAnchor.constraint(equalTo: introduceTextView.trailingAnchor , constant: -5),
            writeContentLabel.bottomAnchor.constraint(equalTo: introduceTextView.bottomAnchor , constant: -5),

         
            
            
            
        
        
        ])
      
  
    }
   
    
    let introduceTextChanged = BehaviorSubject<Int>(value: 0)
        
    var nameText = BehaviorSubject<String>(value: "")
    
    func setBindings(){
        
   
      
        self.nameTextField.rx.text.orEmpty.distinctUntilChanged().bind(to: self.nameText).disposed(by: disposeBag)

        

        Observable.combineLatest( self.nameText.map{ !$0.isEmpty }.distinctUntilChanged()  , self.introduceTextChanged.map{ $0 != 0 }.distinctUntilChanged() ){ $0 && $1}.subscribe(onNext: { event in
            if(event){
                self.addButton.backgroundColor = .black
            }else{
                self.addButton.backgroundColor = .lightGray
            }
            self.addButton.isEnabled = event
            
            
        }).disposed(by: disposeBag)
        

        let input = ChangeIntroduceVM.Input(viewWillApearEvent:  self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }).asObservable() , addButtonTapped : self.addButton.rx.tap.asObservable()  , nameTextField: self.nameText , introduceTextField: self.introduceTextView.rx.text.orEmpty.distinctUntilChanged(),
                                            profileImageTapped : profileImageView.rx.tapGesture().when(.recognized).asObservable() , profileImageValue : self.imageOutput, profileChange: imageChanging.asObservable())
        
        
        
        guard let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag ) else {return}
        
        
        
    
        
        
        Observable.zip(output.name.asObservable() , output.introduce.asObservable() , output.profileImage.asObservable() ).subscribe(onNext: {
            
            
            if  $1.count <= 0 {
         
                
                    print("empty")
                    self.introduceTextView.textColor = .lightGray
                    self.introduceTextView.text = "내 소개를 입력하여 주세요."
            
            }else{
                self.introduceTextView.textColor = .black
                self.writeContentLabel.text = "\($1.count)/\(self.maxCount)"
                self.introduceTextChanged.onNext($1.count)

            }
            
            
            if($0.isEmpty){
                self.addButton.backgroundColor = .lightGray
                self.addButton.isEnabled = false
            }else{
                self.addButton.backgroundColor = .black
                self.addButton.isEnabled = true
                
            }
            
            self.nameTextField.text = $0
            self.nameText.onNext($0)
            
          
            
            
            if($1.isEmpty){
                
                self.introduceTextView.text = "내 소개를 입력하여 주세요."
                self.introduceTextView.textColor = .lightGray
                
            }else{
                self.introduceTextView.text = $1

            }
            
           
            
            if let data = $2 {
                
                if let url = URL(string: data){
                    
                    
                    print(url)
                    DispatchQueue.main.async {
                        
                      
                        
                        
                        let processor = DownsamplingImageProcessor(size: self.profileImageView.bounds.size) // 크기 지정 다운 샘플링
                        // 모서리 둥글게
                        self.profileImageView.kf.indicatorType = .activity  // indicator 활성화
                        self.profileImageView.kf.setImage(
                            with: url,  // 이미지 불러올 url
                            placeholder: self.smileImage,  // 이미지 없을 때의 이미지 설정
                            options: [
                                .processor(processor),
                                .scaleFactor(UIScreen.main.scale),
                                .transition(.fade(0.5)),  // 애니메이션 효과
                                .cacheOriginalImage // 이미 캐시에 다운로드한 이미지가 있으면 가져오도록
                            ])
                        
                        
                        
                     
                        
                        
                        
                    }
                    

                }else{
                    
                    
                    
                    self.profileImageView.image = self.smileImage
                }
                
            }else{

                self.profileImageView.image = self.smileImage
                

            }
            self.topImage.isHidden = false

            
            
        }).disposed(by: disposeBag)
        
        
        

        

       
        
    
        
        self.profileImageView.rx.tapGesture().when(.recognized).subscribe(onNext:{ _ in
            
            self.actionSheetAlert()

        }).disposed(by: disposeBag)
        
        
        
        nameTextField.rx.text.orEmpty.map{ !$0.isEmpty }.distinctUntilChanged().subscribe(onNext:{ [weak self]  event in
            
            self?.addButton.isEnabled = event
            
            if(event){
                self?.addButton.backgroundColor = .black
            }else{
                self?.addButton.backgroundColor = .lightGray
            }
            
            
            
        }).disposed(by: disposeBag )
        
        
    }
    
    
    
 
 
  
   

}


extension ChangeIntroduceVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
     
    func showAlertGoToSetting(text : String) {
       let alertController = UIAlertController(
         title: "현재 \(text) 사용에 대한 접근 권한이 없습니다",
         message: "설정 > HealthySecret 탭에서 \(text) 접근 권한을 허용해주세요",
         preferredStyle: .alert
       )
       let cancelAlert = UIAlertAction(
         title: "취소",
         style: .cancel
       ) { _ in
           alertController.dismiss(animated: true, completion: nil)
         }
       let goToSettingAlert = UIAlertAction(
         title: "설정",
         style: .default) { _ in
           guard
             let settingURL = URL(string: UIApplication.openSettingsURLString),
             UIApplication.shared.canOpenURL(settingURL)
           else { return }
           UIApplication.shared.open(settingURL, options: [:])
         }
       [cancelAlert, goToSettingAlert]
         .forEach(alertController.addAction(_:))
       DispatchQueue.main.async {
         self.present(alertController, animated: true) // must be used from main thread only
       }
     }
    
    func requestCameraPermission(){
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    print("카메라 권한 허용")
                    DispatchQueue.main.async {
                        
                        self.presentCamera()

                    }

                } else {
                    print("카메라 권한 거부")
                    self.showAlertGoToSetting(text: "카메라")
                }
            })
        }
    func checkAlbumPermission(){
            PHPhotoLibrary.requestAuthorization( { status in
                switch status{
                case .authorized:
                    DispatchQueue.main.async {
                        
                        self.presentAlbum()

                    }
                case .denied:
                    self.showAlertGoToSetting(text: "앨범")
                case .restricted, .notDetermined:
                    print("Album: 선택하지 않음")
                default:
                    break
                }
            })
        }
    func actionSheetAlert(){
        let alert = UIAlertController(title: nil , message: nil , preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let replaceImage = UIAlertAction(title: "삭제" , style: .default ){
            [weak self] _ in
            self?.profileImageView.image = self?.smileImage
            self?.profileImageView.layer.cornerRadius = 0
            self?.imageOutput.onNext(nil)
            self?.imageChanging.onNext(true)

        }
        let camera = UIAlertAction(title: "카메라", style: .default) { [weak self] _ in
            self?.requestCameraPermission()
        }
        
        let album = UIAlertAction(title: "앨범", style: .default) { [weak self] _ in
            self?.checkAlbumPermission()
        }
       
        alert.addAction(cancel)
        alert.addAction(camera)
        alert.addAction(album)
        alert.addAction(replaceImage)
       
        alert.view.tintColor = .black
                
        present(alert, animated: true, completion: nil)
        
    }
    
    func presentCamera(){
        
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        vc.cameraFlashMode = .on
        
        present(vc, animated: true, completion: nil)
    }
    
    func presentAlbum(){
        
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        
        present(vc, animated: true, completion: nil)
    }
    
    
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("picker -> \(String(describing: info[UIImagePickerController.InfoKey.imageURL]))")
        
        if cnt % 2 == 0 {
            
            if let image = info[.editedImage] as? UIImage {
                
                self.profileImageView.image = image
                imageOutput.onNext(image)
                imageChanging.onNext(true)
                
            }
            
        }
        else{
            
            if let image = info[.originalImage] as? UIImage {
                self.profileImageView.image = image
                
                imageOutput.onNext(image)
                imageChanging.onNext(true)
            }
            
        }
        self.profileImageView.layer.cornerRadius = 50

        
        cnt += 1
        
        print(cnt)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension ChangeIntroduceVC : UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
   
        if textView.text.count <= 0 {
            
            textView.textColor = .lightGray
            textView.text = "내 소개를 입력하여 주세요."

            
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text.count <= 0 {
            
            textView.textColor = .lightGray
            textView.text = "내 소개를 입력하여 주세요."

            
        }else if(textView.text == "내 소개를 입력하여 주세요." && textView.textColor == .lightGray){
            textView.text = ""
            textView.textColor = .black
            
        }else{
            textView.textColor = .black

        }
       

        
    }
    
    func textView(
           _ textView: UITextView,
           shouldChangeTextIn range: NSRange,
           replacementText text: String
       ) -> Bool {
           
           
           let lastText = textView.text as NSString
           let allText = lastText.replacingCharacters(in: range, with: text)

           let canUseInput = allText.count <= maxCount

           defer {
               if canUseInput {
                   textCount = allText.count
               } else {
                   textCount = textView.text.count
               }
               introduceTextChanged.onNext(textCount)
           }
           
           guard !canUseInput else { return canUseInput }
           
               if textView.text.count < maxCount {
                 
                   
                   let appendingText = text.substring(from: 0, to: maxCount - textView.text.count - 1)
                   textView.text = textView.text.inserting(appendingText, at: range.lowerBound)
                   
                   let isLastCursor = range.lowerBound >= textView.text.count
                   let movingCursorPosition = isLastCursor ? maxCount : (range.lowerBound + appendingText.count)
                   DispatchQueue.main.async {
                       textView.selectedRange = NSMakeRange(movingCursorPosition, 0)
                   }
               } else {

                   DispatchQueue.main.async {
                       textView.selectedRange = NSMakeRange(range.lowerBound, 0)
                   }
               }

           return canUseInput
       }
   }

   extension String {
       func substring(from: Int, to: Int) -> String {
           guard from < count, to >= 0, to - from >= 0 else { return "" }
           let startIndex = index(startIndex, offsetBy: from)
           let endIndex = index(startIndex, offsetBy: to + 1)
           return String(self[startIndex ..< endIndex])
       }
       
       func inserting(_ string: String, at index: Int) -> String {
           var originalString = self
           originalString.insert(contentsOf: string, at: self.index(self.startIndex, offsetBy: index))
           return originalString
       }
   }



   



