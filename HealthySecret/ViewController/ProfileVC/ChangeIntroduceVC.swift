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
        view.layer.cornerRadius = 60
        view.layer.masksToBounds = true

        view.tintColor = .white

      
        return view
        
    }()
    
    private let profileImage : UIImage = {
        let bottomImage = UIImage(named: "일반적.png")
        let topImage = UIImage(named: "camera.png")
        
        
        var bottomSize = CGSize(width: 300, height: 300)
        var topSize = CGSize(width: 80, height: 80)
        UIGraphicsBeginImageContext(bottomSize)

        let areaSize = CGRect(x: 0, y: 0, width: bottomSize.width, height: bottomSize.height)
        let areaSize2 = CGRect(x: 212, y: 220, width: topSize.width, height: topSize.height)
        bottomImage!.draw(in: areaSize)

        topImage!.draw(in: areaSize2 , blendMode: .normal , alpha: 1)

        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
        
    }()
    
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

    
    let introduceTextField : UITextView = {
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

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    var imageOutput = BehaviorSubject<UIImage?>(value: nil)
    var imageChanging = BehaviorSubject<Bool>(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setBindings()
        
    }
    
    
    
    
    

    let labels = [UILabel() , UILabel()]
    let text = ["닉네임" , "내 소개"]
    
    func setUI(){
        
        self.view.addSubview(contentScrollView)
        self.view.addSubview(bottomView)
        
        self.contentScrollView.addSubview(contentView)
        
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(firstView)
        
        firstView.addSubview(nameTextField)
        firstView.addSubview(introduceTextField)
        
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

            
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            profileImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor ),
            profileImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor , constant: 40 ),
            
            firstView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor , constant: 70),
            firstView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 20),
            firstView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -20),
            firstView.heightAnchor.constraint(equalToConstant: 450),
            self.firstView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
           
            labels[0].topAnchor.constraint(equalTo: firstView.topAnchor ),
            labels[0].leadingAnchor.constraint(equalTo: firstView.leadingAnchor),

            nameTextField.topAnchor.constraint(equalTo: labels[0].bottomAnchor , constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo:firstView.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: firstView.trailingAnchor ),
            nameTextField.heightAnchor.constraint(equalToConstant: 60 ),
            
            labels[1].topAnchor.constraint(equalTo: nameTextField.bottomAnchor , constant: 40),
            labels[1].leadingAnchor.constraint(equalTo: firstView.leadingAnchor),
            
            introduceTextField.topAnchor.constraint(equalTo: labels[1].bottomAnchor , constant: 20),
            introduceTextField.leadingAnchor.constraint(equalTo:firstView.leadingAnchor),
            introduceTextField.trailingAnchor.constraint(equalTo: firstView.trailingAnchor ),
            introduceTextField.heightAnchor.constraint(equalToConstant: 260 ),
            
            

         
            
            
            
        
        
        ])
      
  
    }
   
    
    
    
    
    
    func setBindings(){
        
  
       

        
        
        let input = ChangeIntroduceVM.Input(viewWillApearEvent:  self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }).asObservable() , addButtonTapped : self.addButton.rx.tap.asObservable()  , nameTextField: nameTextField.rx.text.orEmpty.distinctUntilChanged().asObservable() , introduceTextField: introduceTextField.rx.text.orEmpty.distinctUntilChanged().asObservable() ,
                                            profileImageTapped : profileImageView.rx.tapGesture().when(.recognized).asObservable() , profileImageValue : self.imageOutput, profileChange: imageChanging.asObservable())
        
        
        
        guard let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag ) else {return}
        
       
        
        
        
        
        Observable.zip(output.name , output.introduce , output.profileImage ).subscribe(onNext: {
            
            self.nameTextField.text = $0
            self.introduceTextField.text = $1
            
            if let data = $2 {
                
                if let url = URL(string: data){
                    
                    
                    
                    DispatchQueue.main.async {
                        
                      
                        
                        
                        let processor = DownsamplingImageProcessor(size: self.profileImageView.bounds.size) // 크기 지정 다운 샘플링
                        // 모서리 둥글게
                        self.profileImageView.kf.indicatorType = .activity  // indicator 활성화
                        self.profileImageView.kf.setImage(
                            with: url,  // 이미지 불러올 url
                            placeholder: UIImage(named: "일반적.png"),  // 이미지 없을 때의 이미지 설정
                            options: [
                                .processor(processor),
                                .scaleFactor(UIScreen.main.scale),
                                .transition(.fade(0.5)),  // 애니메이션 효과
                                .cacheOriginalImage // 이미 캐시에 다운로드한 이미지가 있으면 가져오도록
                            ])
                        
                        
                        
                        
                     
                        
                        
                        
                    }
                    
                    self.profileImageView.layer.cornerRadius = 60

                }
                
//                self.profileImageView.image = UIImage(data: data)
                //self.imageOutput.onNext(UIImage(data:data))


                
            }else{
                self.profileImageView.layer.cornerRadius = 0

                self.profileImageView.image = self.profileImage
                

            }
            
            
            
        }).disposed(by: disposeBag)
        
        
        

        

       
        
    
        
        self.profileImageView.rx.tapGesture().when(.recognized).subscribe(onNext:{ _ in
            self.actionSheetAlert()

            
            
        }).disposed(by: disposeBag)
        
        
        
        
        
    }
    
    
    
 
 
  
   

}


extension ChangeIntroduceVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    func actionSheetAlert(){
        
        let alert = UIAlertController(title: "선택", message: "", preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let replaceImage = UIAlertAction(title: "삭제" , style: .default ){
            [weak self] _ in
            self?.profileImageView.image = self?.profileImage
            self?.profileImageView.layer.cornerRadius = 0
            self?.imageOutput.onNext(nil)
            self?.imageChanging.onNext(true)

        }
        let camera = UIAlertAction(title: "카메라", style: .default) { [weak self] (_) in
            self?.presentCamera()
        }
        let album = UIAlertAction(title: "앨범", style: .default) { [weak self] (_) in
            self?.presentAlbum()
        }
        
        alert.addAction(cancel)
        alert.addAction(camera)
        alert.addAction(album)
        alert.addAction(replaceImage)
        
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
        self.profileImageView.layer.cornerRadius = 60

        
        cnt += 1
        
        print(cnt)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}


