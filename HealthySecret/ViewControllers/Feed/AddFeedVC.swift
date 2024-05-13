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

class AddFeedVC : UIViewController {
    
    let disposeBag = DisposeBag()

    private var viewModel : AddFeedVM?

    var imagesArr : [UIImage] = []
    
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
    
  
    
   
    
    let addFeedTextView : UITextView = {
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
    
        
        button.setTitle("완료", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let firstLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .boldSystemFont(ofSize: 26)
        label.text = "오늘의 일상을\n공유하여 주세요."
        label.numberOfLines = 2
        return label
    }()
    
    
    private let imageLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .gray.withAlphaComponent(0.8)
        label.text = "사진 등록(최대 5장)"
     
        return label
    }()
    
   
    

    
    
    let IMAGE_HEIGHT = CGFloat(100)
    let IMAGE_WIDTH = CGFloat(100)
    let plusImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "plus")
        image.layer.cornerRadius = 30

        image.backgroundColor = .lightGray.withAlphaComponent(0.2)
        image.tintColor = .lightGray.withAlphaComponent(0.6)
        image.widthAnchor.constraint(equalToConstant: 120).isActive = true
        image.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
       return image
    }()
    
    lazy var imageStackView : UIStackView = {
            
 
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
        
    }()
    
    
    
    
    private let informationLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .gray.withAlphaComponent(0.8)
        label.text = "내용"
     
        return label
    }()
    
    
    let imageScrollView = UIScrollView()
    
    //rxSwift
    //
    var imagesDatas = BehaviorSubject<[UIImage]>(value: [])

    
    
    init(viewModel : AddFeedVM){
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
        settingStackView()
        
    }
    
    
    
    func getInputView(image : UIImage ) -> UIView {
        let inputView = UIView()
        let inputImage = UIImageView()
        
      
        inputImage.translatesAutoresizingMaskIntoConstraints = false
        inputView.translatesAutoresizingMaskIntoConstraints = false
        
        inputImage.layer.masksToBounds = true
        inputImage.layer.cornerRadius = 30
        inputImage.image = image
        inputView.addSubview(inputImage)


        
        inputView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        inputView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        
        inputImage.trailingAnchor.constraint(equalTo: inputView.trailingAnchor , constant: 0 ).isActive = true
        inputImage.leadingAnchor.constraint(equalTo: inputView.leadingAnchor , constant: 0).isActive = true
        inputImage.topAnchor.constraint(equalTo: inputView.topAnchor , constant: 0).isActive = true
        inputImage.bottomAnchor.constraint(equalTo: inputView.bottomAnchor , constant: 0).isActive = true
        
        return inputView
    }
    
    
    var index = 0
    func settingStackView(){
        
        self.imagesDatas.onNext(self.imagesArr)
        
        _ = self.imageStackView.arrangedSubviews.map{
            $0.removeFromSuperview()
            
        }
        print("\(self.imageStackView.arrangedSubviews.count ) settingStackview")

        if self.imagesArr.count <= 5 {
            print(imagesArr.count)
            for i in 0..<self.imagesArr.count {
                
              
                let inputView = self.getInputView(image: self.imagesArr[i])
                
                
                
                
                let minusImage = UIButton()
                inputView.addSubview(minusImage)

                self.imageStackView.addArrangedSubview(inputView)
                minusImage.tintColor = .lightGray
                minusImage.translatesAutoresizingMaskIntoConstraints = false
                minusImage.setImage(UIImage(systemName: "x.circle.fill"), for: .normal )
                minusImage.heightAnchor.constraint(equalToConstant: 24).isActive = true
                minusImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
                minusImage.contentVerticalAlignment = .fill
                minusImage.contentHorizontalAlignment = .fill
                minusImage.trailingAnchor.constraint(equalTo: inputView.trailingAnchor  ).isActive = true
                minusImage.topAnchor.constraint(equalTo: inputView.topAnchor ).isActive = true
                minusImage.backgroundColor = .white
                minusImage.layer.cornerRadius = 13
                minusImage.tag = i
                minusImage.addTarget(self, action: #selector(removeImage), for: .touchUpInside )
                
            }
            if(self.imagesArr.count <= 4){
                self.imageStackView.addArrangedSubview(self.plusImage)

            }
            
 
        }else{
            _ = self.imagesArr.map{
                self.imageStackView.addArrangedSubview(self.getInputView(image: $0))
                
            }
        }
        
        
        
    }
    
    
    @objc
    func removeImage(_ sender : UIButton ){
        //self.imageStackView.removeArrangedSubview()
        print("\(sender.tag)  sender tag")

        
        self.imagesArr.remove(at: sender.tag)
        self.settingStackView()
        
    }

    
    let mainView = UIView()

    func setUI(){
        
        self.view.backgroundColor = .white

        
        
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.backgroundColor = .white

        self.view.addSubview(mainView)
        self.mainView.addSubview(contentScrollView)
        self.mainView.addSubview(bottomView)
        
        self.contentScrollView.addSubview(contentView)
        
        bottomView.addSubview(addButton)
        

        contentView.addSubview(imageScrollView)
        contentView.addSubview(addFeedTextView)
        contentView.addSubview(firstLabel)
        contentView.addSubview(informationLabel)
        contentView.addSubview(imageLabel)
        
    
        imageScrollView.addSubview(imageStackView)
    
        
        

            
          
        
        
        
        NSLayoutConstraint.activate([
            
            mainView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            mainView.topAnchor.constraint(equalTo: self.view.topAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: self.mainView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.mainView.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.mainView.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 100),
            
            

            
            addButton.leadingAnchor.constraint(equalTo:bottomView.leadingAnchor , constant: 20),
            addButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20 ),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor , constant: -10 ),
        
            contentScrollView.topAnchor.constraint(equalTo: self.mainView.safeAreaLayoutGuide.topAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: self.mainView.safeAreaLayoutGuide.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: self.mainView.safeAreaLayoutGuide.trailingAnchor),
            
            
            contentView.topAnchor.constraint(equalTo: self.contentScrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.contentScrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.contentScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.contentScrollView.trailingAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600),
            
            
            
            self.contentView.widthAnchor.constraint(equalTo: self.contentScrollView.widthAnchor , multiplier: 1.0),

       
            firstLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            firstLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 20),
            
            imageLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor , constant: 60),
            imageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 20),
            
            imageScrollView.topAnchor.constraint(equalTo: imageLabel.bottomAnchor , constant: 5),
            imageScrollView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor , constant: 20),
            imageScrollView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor , constant: -20),
            imageScrollView.heightAnchor.constraint(equalToConstant: 120),
            
            imageStackView.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor),
            imageStackView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor),

            
            informationLabel.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor , constant: 40),
            informationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 20),
           

            
            addFeedTextView.topAnchor.constraint(equalTo: informationLabel.bottomAnchor , constant: 5),
            addFeedTextView.leadingAnchor.constraint(equalTo:contentView.leadingAnchor , constant: 20),
            addFeedTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -20 ),
            addFeedTextView.heightAnchor.constraint(equalToConstant: 260 ),
            
            

         
            
            
            
        
        
        ])
      
  
    }
   
    
    
    
    
    func setBindings(){

        
        
        let input = AddFeedVM.Input(addButtonTapped: self.addButton.rx.tap.asObservable() , feedText: self.addFeedTextView.rx.text.orEmpty.asObservable() , imagesDatas : imagesDatas.asObservable() )
        
        guard let output = self.viewModel?.transform(input: input, disposeBag: disposeBag) else {return}

       
        self.plusImage.rx.tapGesture().when(.recognized).subscribe(onNext:{ _ in
            self.actionSheetAlert()

            
            
        }).disposed(by: disposeBag)
        

        
       
        
    }
    
 
  
    
   
    




}

extension AddFeedVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func actionSheetAlert(){
        
        let privacyChecker = PrivacyChecker(viewController: self)
        
        let alert = UIAlertController(title: "선택", message: "", preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        let camera = UIAlertAction(title: "카메라", style: .default) { [weak self] (_) in
            privacyChecker.requestCameraPermission()
        }
        let album = UIAlertAction(title: "앨범", style: .default) { [weak self] (_) in
            privacyChecker.requestAlbumPermission()
        }
        
        alert.addAction(cancel)
        alert.addAction(camera)
        alert.addAction(album)
        //alert.addAction(replaceImage)
        
        present(alert, animated: true, completion: nil)
        
    }
    
   
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("picker -> \(String(describing: info[UIImagePickerController.InfoKey.imageURL]))")
        
        
        
        var newImage: UIImage? = nil // update 할 이미지
               
               if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                   newImage = possibleImage // 수정된 이미지가 있을 경우
               } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                   newImage = possibleImage // 원본 이미지가 있을 경우
               }
        
       

        guard let newImage = newImage else {return}
        
        
        
        
 
        
        
        self.imagesArr.append(newImage)
        
        self.settingStackView()
        
        dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}






