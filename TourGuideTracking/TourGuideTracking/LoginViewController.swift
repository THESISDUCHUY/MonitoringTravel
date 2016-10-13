//
//  LoginViewController.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/6/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    
    //@IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogin.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func onTapScreen(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    @IBAction func phoneTextFieldEditingChanged(_ sender: AnyObject) {
        setButtonLogin()
    }
    
    @IBAction func passwordEditingChanged(_ sender: AnyObject) {
       setButtonLogin()
    }
    
    @IBAction func btnLoginTouchDown(_ sender: AnyObject) {
        if (self.phoneTextField.text?.characters.count)! < 10{
            alertMessage(userMessage: "Phone number invalid!")
        }
        else{
           
            let parameters:[String:Any] = ["phone":phoneTextField.text!, "password":passwordTextField.text!]
            NetworkService<TourGuide>.makePostRequest(URL: URLs.URL_LOGIN, data: parameters){
                response, error in
                if error == nil{
                    let message = response?.message
                    if(message == nil){
                        //set data 
                        let tourguide = response?.data
                        
                        //save setting tourist_id, access_token
                        UserDefaults.standard.set(tourguide?.tourGuideId,forKey: Keys.TOURGUIDE_ID)
                        UserDefaults.standard.set(tourguide?.accessToken,forKey: Keys.TOURGUIDE_ACCESSTOKEN)
                        if(tourguide?.tourGuideId != nil){
                            
                            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let initViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: ViewIdentifier.MYTOURS_VIEW) as UIViewController
                            self.present(initViewController, animated: true, completion: nil)
                            //self.performSegue(withIdentifier: SegueIdentifier.TO_MY_TOURS, sender: self)
                        }
                    }
                    else {
                        self.alertMessage(userMessage: message!)
                    }
                }
                else{
                    self.alertMessage(userMessage:"Đã có lỗi xảy ra!")
                }
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        /*bottomConstraint.constant = 250
         UIView.animate(withDuration: 0.3) {
         self.view.layoutIfNeeded()
         }*/
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        /*bottomConstraint.constant = 149
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }*/
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height/2
            }
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
    
    func alertMessage(userMessage:String){
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
