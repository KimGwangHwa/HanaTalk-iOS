//
//  EditUserInfoViewController.swift
//  talk
//
//  Created by ひかりちゃん on 2018/02/11.
//

import UIKit
import RxCocoa
import RxSwift

fileprivate let editCellIdentifier = R.reuseIdentifier.editUserInfoCell.identifier

class EditUserInfoViewController: UIViewController {
    var usecase: UserInfoUseCase!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    
    }
    
    func setup() {
        doneBarButton.tintColor = HanaWhiteTextColor
        navigationBarColor = HanaBackgroundColor
        tableView.backgroundColor = HanaBackgroundColor
        setNavigationBarBackIndicatorImage(#imageLiteral(resourceName: "icon_back"))
        tableView.register(R.nib.editUserInfoCell(), forCellReuseIdentifier: editCellIdentifier)
        tableView.tableFooterView = UIView()
        profileImageView.sd_setImage(with: URL(string: usecase.model.profileUrl), placeholderImage: R.image.placeholderImage())
        _ = usecase.editModel.profileImage.bind(to: profileImageView.rx.image)
        if !usecase.editModel.configured {
            navigationItem.leftBarButtonItem = nil;
        }
        
        usecase.valueChanged { (isEmpty) in
            self.doneBarButton.isEnabled = !isEmpty
        }
    }
    
    func moveToSideMenu() {
        dismiss(animated: true, completion: nil)
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            let sidMenuViewController = SideMenuViewController.shared
            appdelegate.window?.rootViewController = sidMenuViewController
            appdelegate.window?.makeKeyAndVisible()
        }
    }
    
    @IBAction func tappedCancel(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func tappedDone(_ sender: UIBarButtonItem) {
        usecase.uploadEdited { (isSuccess) in
            self.moveToSideMenu()
        }
    }
    
    @IBAction func tappedChangeProfile(_ sender: UIButton) {
        UIAlertController.show(in: self, {
            let imageViewController = UIImagePickerController()
            imageViewController.delegate = self
            imageViewController.sourceType = .camera
            self.present(imageViewController, animated: true, completion: nil)
        }) {
            let imageViewController = UIImagePickerController()
            imageViewController.delegate = self
            imageViewController.sourceType = .photoLibrary
            self.present(imageViewController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Table view data source
extension EditUserInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: editCellIdentifier, for: indexPath) as? EditUserInfoCell,
            let infoRow = UserInfoType(rawValue: indexPath.row) {
            cell.nameLabel?.text = infoRow.name
            //cell.backgroundColor = WeakBackgroundColor
            switch infoRow {
            case .nickname:
                _ = usecase.editModel.nickname.bind(to: cell.descriptionLabel.rx.text)
                break
            case .birthDay:
                _ = usecase.editModel.birthDay.bind(to: cell.descriptionLabel.rx.text)
                break
            case .sex:
                _ = usecase.editModel.sex.bind(to: cell.descriptionLabel.rx.text)
                break
            case .bio:
                _ = usecase.editModel.bio.bind(to: cell.descriptionLabel.rx.text)
                break
            case .email:
                _ = usecase.editModel.mail.bind(to: cell.descriptionLabel.rx.text)
                break
            case .phoneNumber:
                _ = usecase.editModel.tel.bind(to: cell.descriptionLabel.rx.text)
                break
            }
            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserInfoType.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let infoRow = UserInfoType(rawValue: indexPath.row)  {
            switch infoRow {
            case .sex:
                let dataSource = [Sex.female.name, Sex.male.name]
                PickerDialog.show(defaultText: usecase.editModel.sex.value, dataSource: dataSource) { (value) in
                    self.usecase.editModel.sex.accept(value)
                }
                return
            case .birthDay:
                let defaultDate = usecase.editModel.birthDay.value.date(format: .date) ?? Date()
                DatePickerDialog.show(defaultDate: defaultDate) { (date) in
                    self.usecase.editModel.birthDay.accept(date.string(format: .date))
                }
                return
            default:
                break
            }

            if let viewController = R.storyboard.inputMessage.inputMessageViewController() {
                viewController.userInfoType = infoRow
                viewController.model = usecase.editModel
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension EditUserInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            usecase.editModel.profileImage.accept(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: UITextViewDelegate
//extension EditUserInfoViewController: UITextViewDelegate {
//    func textViewDidChange(_ textView: UITextView) {
//        tableView.beginUpdates()
//        tableView.endUpdates()
//    }
//}



