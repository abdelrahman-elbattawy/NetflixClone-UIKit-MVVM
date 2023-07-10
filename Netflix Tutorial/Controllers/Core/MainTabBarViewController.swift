//
//  ViewController.swift
//  Netflix Tutorial
//
//  Created by Aboody on 06/07/2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    //MARK: - Properties
    private let homeViewController: UINavigationController = {
       
        let viewController = UINavigationController(rootViewController: HomeViewController())
        viewController.title = "Home"
        viewController.tabBarItem.image = UIImage(systemName: "house")
        return viewController
        
    }()
    
    private let upcomingViewController: UINavigationController = {
       let viewController = UINavigationController(rootViewController: UpcomingViewController())
        viewController.title = "Coming Soon"
        viewController.tabBarItem.image = UIImage(systemName: "play.circle")
        return viewController
    }()
    
    private let searchViewController: UINavigationController = {
       let viewController = UINavigationController(rootViewController: SearchViewController())
        viewController.title = "Top Search"
        viewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        return viewController
    }()
    
    private let downloadViewController: UINavigationController = {
       let viewController = UINavigationController(rootViewController: DownloadsViewController())
        viewController.title = "Downloads"
        viewController.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        return viewController
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: - Helper Functions
    private func setupUI() {
        
        tabBar.tintColor = .label
        
        setViewControllers([
            homeViewController,
            upcomingViewController,
            searchViewController,
            downloadViewController
        ], animated: true)
    }

}

