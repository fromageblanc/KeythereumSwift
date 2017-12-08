//
//  ViewController.swift
//  KeythereumSwift
//
//  Created by Seiji.Y. on 2017/12/07.
//  Copyright © 2017年 Seiji.Y. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var keyStoreText:UITextView!
    @IBOutlet weak var passwordField:UITextField!
    @IBOutlet weak var secretKeyLabel:UILabel!
    
    // ダミーのWebview. JS実行用
    var webView = UIWebView()

    // テキストフィールド外をタップするとキーボードを隠す
    @IBAction func hiddenKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @IBAction func extractPrivateKey(_ sender:UIButton) {
        
        // javascript:privateKey()のパラメタ
        var param1:String = ""
        let param2 = passwordField.text!

        // keyStoreTextの複数行を１行にする
        keyStoreText.text?.enumerateLines { (line, stop) -> () in
            param1 += line.trimmingCharacters(in:.whitespacesAndNewlines)
        }
        
        // js評価文字列作成
        let jsEvalStr = "privateKey('" + param1 + "','" + param2 + "');"
        
        let privateKey = webView.stringByEvaluatingJavaScript(from:jsEvalStr)
        secretKeyLabel.text = (privateKey == "") ? "fail to generate secret key" : privateKey

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // ローカルのkeythereum.htmlをロード
        let html = Bundle.main.path(forResource: "keythereum", ofType: "html")
        webView.loadRequest(URLRequest(url: URL(string: html!)!))
        
        // パスワードフィールドを伏せ字モードに
        passwordField.isSecureTextEntry = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

