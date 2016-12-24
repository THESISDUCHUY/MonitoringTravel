//
//  WarningPopup.swift
//  TouristTracking
//
//  Created by Quoc Huy Ngo on 12/16/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

@objc protocol WarningPopupDelegate {
    func sendWarning(content:String)
}
class WarningPopup: UIView{
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var panel: UIView!
    @IBOutlet weak var backgroundEffectView: UIVisualEffectView!
    var delegate:WarningPopupDelegate!
    var isTextViewChanged = false
    let content = "Nội dung trợ giúp!"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubview()
    }
    
    @IBOutlet weak var wrapDialog: UIView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubview()
    }
    func initSubview(){
        
        let nib = UINib(nibName: "WarningPopup", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        //view.backgroundColor = UIColor.red
        addSubview(view)
        
        addTapEvent()
        contentTextView.delegate = self
        contentTextView.text = content
        contentTextView.textColor = UIColor.gray
        panel.layer.cornerRadius = 6
        panel.layer.shadowColor = UIColor.black.cgColor
        contentTextView.layer.borderColor = UIColor.gray.cgColor
        contentTextView.layer.borderWidth = 1
    }
    
    @IBAction func onClose(_ sender: Any) {
        self.removeFromSuperview()
    }
    func addTapEvent(){
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(onTap))
        backgroundEffectView.addGestureRecognizer(tap)
    }
    
    func onTap(){
        if isTextViewChanged{
            isTextViewChanged = false
            endEditing(true)
            UIView.animate(withDuration: 0.5, animations: {
                self.wrapDialog.transform = CGAffineTransform(translationX: 0, y: 26)
            })
        }
    }
    @IBAction func sendButton(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            let a = self.contentTextView.text
            self.delegate.sendWarning(content: self.contentTextView.text)
              self.removeFromSuperview()
        })
      
    }
}

extension WarningPopup: UITextViewDelegate{
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        isTextViewChanged = true
        if textView.text == content {
            contentTextView.text = ""
            contentTextView.textColor = UIColor.black
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.wrapDialog.transform = CGAffineTransform(translationX: 0, y: -80)
        })
    }
    public func textViewDidEndEditing(_ textView: UITextView){
        if textView.text == ""{
            contentTextView.text = content
            contentTextView.textColor = UIColor.gray
        }
    }
}
