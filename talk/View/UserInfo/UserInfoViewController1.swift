//
//  UserInfoViewController.swift
//  talk
//
//  Created by ひかりちゃん on 2017/08/27.
//
//

import UIKit

class UserInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public var userId: String = ""
    @IBOutlet weak var tableview: UITableView!
    private var reuseIdentifiers = [R.reuseIdentifier.profileImageCell.identifier, R.reuseIdentifier.nickName.identifier, R.reuseIdentifier.statusCell.identifier, R.reuseIdentifier.phoneNumberCell.identifier, R.reuseIdentifier.emailCell.identifier, R.reuseIdentifier.sexCell.identifier, R.reuseIdentifier.birthdayCell.identifier, R.reuseIdentifier.postsCell.identifier, R.reuseIdentifier.followingCell.identifier, R.reuseIdentifier.followerCell.identifier, R.reuseIdentifier.actionCell.identifier]

    private var userInfo: UserInfo? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        readData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
    func readData() {
        UserInfoApi.findUserInfo(with: userId) { (response) in
            if response.status == .success {
                self.userInfo = response.data
                self.tableview.reloadData()
            }
        }
    }
    
    func setUpView() {
        tableview.tableFooterView = UIView(frame: CGRect.zero)
    }

    // MARK: - ActionEvent

    @IBAction func followEvent(_ sender: UIButton) {
    
    }
    
    @IBAction func sendMessageEvent(_ sender: UIButton) {
    
    }
    
    // MARK: - UITableViewDelegate
    
    // Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reuseIdentifiers.count
    }
    
    // CellForRow
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifiers[indexPath.row], for: indexPath) as? UserInfoCell {
            cell.userInfo = userInfo
            return cell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if reuseIdentifiers[indexPath.row] == R.reuseIdentifier.profileImageCell.identifier {
            return 100
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cellIdentifier = reuseIdentifiers[indexPath.row]
        if cellIdentifier == R.reuseIdentifier.profileImageCell.identifier {
            showAlertSheet()
        } else if cellIdentifier == R.reuseIdentifier.nickName.identifier || cellIdentifier == R.reuseIdentifier.statusCell.identifier || cellIdentifier == R.reuseIdentifier.phoneNumberCell.identifier || cellIdentifier == R.reuseIdentifier.emailCell.identifier || cellIdentifier == R.reuseIdentifier.birthdayCell.identifier {
            
            if let inputViewController = R.storyboard.infoInput.infoInputViewController() {
                if cellIdentifier == R.reuseIdentifier.nickName.identifier {
                    inputViewController.type = .nickName
                } else if cellIdentifier == R.reuseIdentifier.statusCell.identifier {
                    inputViewController.type = .statusMessage
                } else if cellIdentifier == R.reuseIdentifier.phoneNumberCell.identifier {
                    inputViewController.type = .phoneNumber
                } else if cellIdentifier == R.reuseIdentifier.emailCell.identifier {
                    inputViewController.type = .email
                } else if cellIdentifier == R.reuseIdentifier.birthdayCell.identifier {
                    inputViewController.type = .birthDay
                }
                navigationController?.pushViewController(inputViewController, animated: true)
            }

        } else if cellIdentifier == R.reuseIdentifier.postsCell.identifier || cellIdentifier == R.reuseIdentifier.followingCell.identifier || cellIdentifier == R.reuseIdentifier.followerCell.identifier {
            
        }
        
    }
    
    // MARK: - ImagePickerController delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        albumImage = info[UIImagePickerControllerOriginalImage] as? UIImage
//        
//        DataManager.shared.currentUserInfo?.uploadProfilePicture(image: albumImage!, completion: { (isSuccess) in
//            self.tableView.reloadData()
//        })
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - UIAlertController
    
    func showAlertSheet() {
        let alertViewController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertViewController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        alertViewController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert) in
            alertViewController.dismiss(animated: true, completion: nil)
            let sourceType: UIImagePickerControllerSourceType = .camera
            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                let picker = UIImagePickerController()
                picker.sourceType = sourceType
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }
        }))
        alertViewController.addAction(UIAlertAction(title: "Album", style: .default, handler: { (alert) in
            alertViewController.dismiss(animated: true, completion: nil)
            let sourceType: UIImagePickerControllerSourceType = .savedPhotosAlbum
            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                let picker = UIImagePickerController()
                picker.sourceType = sourceType
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }
            
        }))
        present(alertViewController, animated: true, completion: nil)
    }

    
    
}