//
//  TitlePreviewViewController.swift
//  Netflix Tutorial
//
//  Created by Aboody on 08/07/2023.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    //MARK: - Properties
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Harry Potter"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleOverview: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "This is the best movie ever to watch as a kid!"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        applyConstraints()
    }
    
    //MARK: - Helper Functions
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(titleOverview)
        view.addSubview(downloadButton)
    }
    
    private func applyConstraints() {
        let webViewConstraints = [
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            webView.heightAnchor.constraint(equalToConstant: 350)
        ]
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20)
        ]
        
        let titleOverviewConstraints = [
            titleOverview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleOverview.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            titleOverview.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.heightAnchor.constraint(equalToConstant: 40),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.topAnchor.constraint(equalTo: titleOverview.bottomAnchor, constant: 25)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(titleOverviewConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    public func configue(with model: TitlePreviewModelView) {
        titleLabel.text = model.titleName
        titleOverview.text = model.titleOverview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.videoElement.id.videoId)") else {return}
        webView.load(URLRequest(url: url))
    }
}

