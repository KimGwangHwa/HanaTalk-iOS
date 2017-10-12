//
//  SigUpViewController.swift
//  talk
//
//  Created by ひかりちゃん on 2017/07/31.
//
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    
    private var sex: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupEvent(_ sender: Any) {
        
        let signupUser = User(className: "_User");
        signupUser.username = userIdTextField.text
        signupUser.password = passwordTextField.text
        signupUser.signUpWithCompletion { (isSuccess) in
            let addUserInfo = UserInfo()
            addUserInfo.nickName = self.nickNameTextField.text
            addUserInfo.sex = self.sex
            addUserInfo.userId = signupUser.objectId ?? ""
            addUserInfo.birthday = Common.stringToDate(dateString: self.birthdayTextField.text, format: DATE_FORMAT_2)
            addUserInfo.saveInBackground(block: { (isSuccess, error) in
                if isSuccess {
                    NSLog("adfasdf")
                }
            })
        }
    }
    
    @IBAction func sexSelectEvent(_ sender: UIButton) {
    
    }
    
    @IBAction func closeEvent(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}