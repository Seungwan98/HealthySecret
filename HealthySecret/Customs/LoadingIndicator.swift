//
//  LoadingScene.swift
//  HealthySecret
//
//  Created by 양승완 on 4/2/24.
//

import Foundation
import UIKit
class LoadingIndicator {
    static func showLoading() {
        DispatchQueue.main.async {
            // 최상단에 있는 window 객체 획득
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            guard let window = windowScene?.windows.last else { return }

            let loadingIndicatorView: UIActivityIndicatorView
            if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = UIActivityIndicatorView(style: .large)
                /// 다른 UI가 눌리지 않도록 indicatorView의 크기를 full로 할당
                loadingIndicatorView.frame = window.frame
                loadingIndicatorView.color = .lightGray
                window.addSubview(loadingIndicatorView)
            }

            loadingIndicatorView.startAnimating()
        }
    }

    static func hideLoading() {
        DispatchQueue.main.async {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            guard let window = windowScene?.windows.last  else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }
    }
}



final class LoadingView: UIView {
  private let backgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  private let activityIndicatorView: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView(style: .large)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  var isLoading = false {
    didSet {
      self.isHidden = !self.isLoading
      self.isLoading ? self.activityIndicatorView.startAnimating() : self.activityIndicatorView.stopAnimating()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.addSubview(self.backgroundView)
    self.addSubview(self.activityIndicatorView)
    
    NSLayoutConstraint.activate([
      self.backgroundView.leftAnchor.constraint(equalTo: self.leftAnchor),
      self.backgroundView.rightAnchor.constraint(equalTo: self.rightAnchor),
      self.backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      self.backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
    ])
    NSLayoutConstraint.activate([
      self.activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      self.activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
    ])
  }
  required init?(coder: NSCoder) {
    fatalError()
  }
}
