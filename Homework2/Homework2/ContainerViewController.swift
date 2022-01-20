//
//  ContainerViewController.swift
//  Homework2
//
//  Created by Ufuk Canlı on 20.01.2022.
//

import UIKit

final class ContainerViewController: UIViewController {
    
    private let pageViewController: UIPageViewController
    private var pages = [UIViewController]()
    private var currentVC: UIViewController
    private var currentVCIndex = 0
    private var isTimerStarted = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        
        let page1 = ViewController1()
        let page2 = ViewController2()
        let page3 = ViewController3()
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        currentVC = pages.first!
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isTimerStarted { startTimer() }
    }
}


// MARK: - Helper Methods

private extension ContainerViewController {
    
    func configureViewController() {
        view.backgroundColor = .systemPurple
                
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        pageViewController.dataSource = self
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: pageViewController.view.topAnchor),
            view.leadingAnchor.constraint(equalTo: pageViewController.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: pageViewController.view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: pageViewController.view.bottomAnchor),
        ])
        
        pageViewController.setViewControllers(
            [pages.first!],
            direction: .forward,
            animated: false,
            completion: nil
        )
        currentVC = pages.first!
    }
    
    func startTimer() {
        isTimerStarted = true
        let timer = Timer.scheduledTimer(
            withTimeInterval: 5.0,
            repeats: true
        ) { [self] timer in
            if currentVCIndex == pages.count - 1 {
                currentVCIndex = 0
                pageViewController.setViewControllers(
                    [pages[currentVCIndex]],
                    direction: .forward,
                    animated: false,
                    completion: nil
                )
            } else {
                currentVCIndex += 1
                pageViewController.setViewControllers(
                    [pages[currentVCIndex]],
                    direction: .forward,
                    animated: false,
                    completion: nil
                )
            }
        }
        timer.fire()
    }
}


// MARK: - UIPageViewControllerDataSource

extension ContainerViewController: UIPageViewControllerDataSource {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        return getPreviousViewController(from: viewController)
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        return getNextViewController(from: viewController)
    }

    private func getPreviousViewController(
        from viewController: UIViewController
    ) -> UIViewController? {
        currentVC = pages[currentVCIndex - 1]
        return pages[currentVCIndex - 1]
    }

    private func getNextViewController(
        from viewController: UIViewController
    ) -> UIViewController? {
        currentVC = pages[currentVCIndex + 1]
        return pages[currentVCIndex + 1]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentVCIndex
    }
}


// MARK: - ViewControllers

final class ViewController1: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemRed
    }
}

final class ViewController2: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGreen
    }
}

final class ViewController3: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
    }
}
