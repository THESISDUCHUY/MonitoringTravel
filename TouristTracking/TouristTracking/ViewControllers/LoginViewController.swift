//
//  LoginViewController.swift
//  TouristTracking
//
//  Created by Quoc Huy Ngo on 12/5/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: UIViewController {

   
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setRecognizer()
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func onTapScreen(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    @IBAction func PhoneTextFieldEditingChanged(_ sender: Any) {
        setButtonLogin()
    }
    
    @IBAction func PasswordTextFieldEditingChanged(_ sender: Any) {
        setButtonLogin()
    }
    
    @IBAction func onLogin(_ sender: Any) {
        if (self.phoneTextField.text?.characters.count)! < 10{
            Alert.showAlertMessage(userMessage:  "Phone number invalid!", vc: self)
        }
        else{
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let parameters:[String:Any] = ["phone":phoneTextField.text!, "password":passwordTextField.text!]
            print(URLs.URL_LOGIN)
            NetworkClient<Tourist>.makePostRequest(URL: URLs.URL_LOGIN, data: parameters){
                response, error in
                if error == nil{
                    let message = response?.message
                    if(message == nil){
                        //set data
                        let tourist = response?.data
                        
                        if(tourist?.touristId != nil){
                            //save setting tourist_id, access_token
                            UserDefaults.standard.set(tourist?.touristId,forKey: SettingKeys.TOURIST_ID)
                            UserDefaults.standard.set(tourist?.accessToken,forKey: SettingKeys.TOURIST_ACCESSTOKEN)
                            Settings.tourist_id = tourist?.touristId
                            Settings.tourist_accesstoken = tourist?.accessToken
                            self.performSegue(withIdentifier: SegueIdentifier.SegueTabBar, sender: self)
                            //self.touristInfoGet()
                        }
                    }
                    else {
                        Alert.showAlertMessage(userMessage: message!, vc: self)
                    }
                }
                else{
                    Alert.showAlertMessage(userMessage:"Đã có lỗi xảy ra!", vc: self)
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
    }
    
    func touristInfoGet(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkClient<Tourist>.makeGetRequest(URL: URLs.makeURL(url: URLs.URL_GET_TOURIST, param: Settings.tourist_id!) ){
            response, error in
            if error == nil{
                let message = response?.message
                if message == nil{
                    let tourist = response?.data
                    Singleton.sharedInstance.tourist = tourist
                    //self.toursGet()
                }
                else{
                    Alert.showAlertMessage(userMessage: message!, vc: self)
                }
            }
            else{
                Alert.showAlertMessage(userMessage: ERROR_MESSAGE.CONNECT_SERVER, vc: self)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func setButtonLogin(){
        if phoneTextField.text != "" && passwordTextField.text != ""{
            btnLogin.isEnabled = true
        }
        else{
            btnLogin.isEnabled = false
        }
    }
    
    func setRecognizer(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapScreen(_ : )))
        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height/2
            }
        }
    }

    
}
