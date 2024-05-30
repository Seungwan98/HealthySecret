
import UIKit
import RxSwift
final class SplashVC: UIViewController {
    private let viewModel: SplashVM
    init(viewModel: SplashVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.view.backgroundColor = .white
        setAutoLayout()
        startAnimation()
        
        viewModel.selectStart()
        
       
        
        viewModel.freeze.subscribe(onNext: { [weak self] _ in
            guard let self else {return}
            print("feeze")
            AlertHelper.shared.showResult(title: "계정 정지", message: "신고 누적으로 계정이 정지되었습니다" , over: self)
            
        }).disposed(by: disposeBag)
        
    }
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "mainImage.jpeg")
        return imageView
    }()
     private lazy var mainView: UIImageView = {
        let view = UIImageView()
         view.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        return view
    }()
    
    func startAnimation() {
//        UIView.animate(withDuration: 1.2, delay: 0.1, options: [ ], animations: {
//            self.logoImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//            
//        }, completion: nil)
    }
    
    private func setAutoLayout() {
        view.addSubview(mainView)

        view.addSubview(logoImageView)

        mainView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 240),
            logoImageView.widthAnchor.constraint(equalToConstant: 240),
            
            mainView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor ),
        ])
    }
}
