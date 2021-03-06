//
//  ViewController.swift
//  KeythereumSwift
//
//  Created by Seiji.Y. on 2017/12/07.
//  Copyright © 2017年 Seiji.Y. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var keyStoreText:UITextView!
    @IBOutlet weak var passwordField:UITextField!
    @IBOutlet weak var secretKeyLabel:UILabel!
    
    // ダミーのWebview. JS実行用
    //var webView = UIWebView()
    var webView = WKWebView()
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
        
        //let privateKey = webView.stringByEvaluatingJavaScript(from:jsEvalStr)
        webView.evaluateJavaScript(jsEvalStr, completionHandler: {(res,error) in
            guard let pk = res else {
                self.secretKeyLabel.text = "fail to decode private key"
                return
            }
            
            self.secretKeyLabel.text = pk as? String
        })

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // ローカルのkeythereum.htmlをロード
//        let html = Bundle.main.path(forResource: "keythereum", ofType: "html")
//        webView.loadRequest(URLRequest(url: URL(string: html!)!))
        
        let url = Bundle.main.url(forResource: "keythereum", withExtension: ".html")!
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        
        // パスワードフィールドを伏せ字モードに
        passwordField.isSecureTextEntry = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

