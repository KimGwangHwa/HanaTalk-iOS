//
//  EventViewController.swift
//  Hana
//
//  Created by kimgwanghwa on 2018/06/11.
//

import UIKit
import RxSwift

class EventViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let usecase = EventUseCase()
    var data: [EventModel]?
    let cellReuseIdentifier = R.reuseIdentifier.eventCell.identifier
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        tableView.tableFooterView = UIView()
        tableView.register(R.nib.eventCell(), forCellReuseIdentifier: cellReuseIdentifier)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(tableviewRefresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableviewRefresh(refreshControl)
    }

    @objc func tableviewRefresh(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        usecase.read { (list, isSuccess) in
            self.data = list
            self.tableView.reloadData()
            sender.endRefreshing()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedEvent(_ sender: UIButton) {
        SideMenuViewController.show()
    }
    
    @IBAction func tappedCreat(_ sender: UIButton) {
        if let viewController = R.storyboard.createEvent.instantiateInitialViewController(),
            let rootViewController = viewController.viewControllers.first as? CreateEventViewController {
            rootViewController.usecase = usecase
            present(viewController, animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension EventViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.width / 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? EventCell {
            cell.model = data![indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}
