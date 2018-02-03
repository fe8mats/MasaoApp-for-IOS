//
//  ViewController.swift
//  MasaoProducer
//
//  Created by Tetsuya Matsuda on 2017/09/28.
//  Copyright © 2017 Tex. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation
import Firebase

var flag_qr1: Bool = false
var flag_qr2: Bool = false
var str_qr1:String = "nnn" //Data read from QR

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

class ViewController3: UIViewController {
    
    @IBOutlet weak var cameraView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

class CameraController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var rotate_prev = 0
    @IBOutlet weak var btn1_qr: UIButton!
    var video = AVCaptureVideoPreviewLayer()
    //Status bar
    let rect1 = UIView()
    var camera_c = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if (status == AVAuthorizationStatus.authorized || status == AVAuthorizationStatus.notDetermined) {
            //If can launch camera
            //Creating Session
            let session = AVCaptureSession()
            flag_qr1 = true
            //Define capture device
            let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            
            do
            {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                session.addInput(input)
            }
            catch
            {
                print("QR Capture Error")
                
            }
        
        
        
            if (captureDevice != nil) {
                // Debug
                print(captureDevice!.localizedName)
                print(captureDevice!.modelID)
            } else {
                print("Missing Camera")
                return
            }
        
            let output = AVCaptureMetadataOutput()
            session.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            video = AVCaptureVideoPreviewLayer(session: session)
            //Reset size of preview layer
            Reset_videoView()
            //Set video preview layer
            view.layer.addSublayer(video)
            session.startRunning()
        } else{
            print("permission error")
            camera_c = false
        }
        // Do any additional setup after loading the view, typically from a nib.

        //Create status bar
        rect1.frame = CGRect(x:0,y:0,width:self.view.bounds.width,height:20)
        rect1.backgroundColor = #colorLiteral(red: 0.391697526, green: 0.7094672322, blue: 0.9616494775, alpha: 1)
        self.view.addSubview(rect1)
        
        //Cancel button
        btn1_qr.addTarget(self, action: #selector(btn1_qr_Event(sender:)), for: .touchUpInside)
        self.view.bringSubview(toFront: btn1_qr)
        
    }
    //Click on Cancel button
    func btn1_qr_Event(sender: UIButton) {
        print("Pushed Cancel button")
        flag_qr1 = false
        flag_qr2 = false
        str_qr1 = "nnn"
        self.dismiss(animated: true, completion: nil)
    }
    //Capture QR
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects != nil && metadataObjects.count != 0
        {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObjectTypeQRCode
                {
                    if flag_qr1 == true
                    {
                    if object.stringValue!.hasPrefix("ms_app://")
                    {
                        flag_qr1 = false
                        let alert = UIAlertController(title: "QR Code", message: "Do you play this game?", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: { (nil) in
                            flag_qr1 = true
                        }))
                        alert.addAction(UIAlertAction(title: "Play", style: .default, handler: { (nil) in
                        UIPasteboard.general.string = "\(object.stringValue!)"
                            str_qr1 = "\(object.stringValue!)"
                            flag_qr2 = true
                            self.dismiss(animated: true, completion: nil)
                        }))
                    
                        present(alert, animated: true, completion: nil)
                    }
                    }
                }
            }
        }
        
    }
    //Detect device direction
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.onOrientationChange(notification:)),name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    //Reset preview layer
    func Reset_videoView(){
        switch UIDevice.current.orientation {
        case UIDeviceOrientation.landscapeLeft:
            if(camera_c){video.connection.videoOrientation = .landscapeRight}
            rect1.isHidden = true
            rotate_prev = 1
        case UIDeviceOrientation.landscapeRight:
            if(camera_c){video.connection.videoOrientation = .landscapeLeft}
            rect1.isHidden = true
            rotate_prev = 2
        case UIDeviceOrientation.portrait:
            if(camera_c){video.connection.videoOrientation = .portrait}
            rect1.isHidden = false
            rotate_prev = 0
        case UIDeviceOrientation.portraitUpsideDown:
            
            if rotate_prev == 1
            {
                if(camera_c){video.connection.videoOrientation = .landscapeRight}
                rect1.isHidden = true
            }
            else if rotate_prev == 2
            {
                if(camera_c){video.connection.videoOrientation = .landscapeLeft}
                rect1.isHidden = true
            }
            else{
                if(camera_c){video.connection.videoOrientation = .portraitUpsideDown}
                rect1.isHidden = false
            }
            
        default:
            if(camera_c){video.connection.videoOrientation = .portrait}
            rect1.isHidden = false
            rotate_prev = 0
        }
        
        video.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
        
    }
    //Redraw after detect direction
    func onOrientationChange(notification: NSNotification){
        Reset_videoView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Simple Alert function
    func SimpleAlert(altitle: String, almes: String) {
        let alertController = UIAlertController(title: altitle,message: almes, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
            print("Alert showed")
        }
        alertController.addAction(okAction)
        present(alertController,animated: true,completion: nil)
        
    }
}
//MasaoApp main UI
class ViewController2: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name)
        if(message.name == "callbackLogin") {
            print(message.body)
            SimpleAlert(altitle: "Oops!", almes: "Sorry, it's not supported yet.")
        }
        if(message.name == "callbackCopy") {
            let board = UIPasteboard.general
            board.string = "\(message.body)"
            SimpleAlert(altitle: "Copied", almes: "HTML data is copied to the clipboard!")
        }
        //Callback : Delete Project
        if(message.name == "callbackDeletefile") {
            //Create Alert
            let alert = UIAlertController(
                title: "Delete Project",
                message: "Do you want to delete '\(message.body)'?\nIt cannot be restored after deleted.",
                preferredStyle: .alert)
            
            //Button on Alert
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                let file_name = message.body
                print(file_name)
                if let dir = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask ).first {
                    
                    let path_file_name = dir.appendingPathComponent( file_name as! String )
                    
                    do {
                        
                        try FileManager.default.removeItem(at: path_file_name)
                        print("deleted")
                        
                        self.Make_Lists()
                    } catch {
                        //Error
                        print("not deleted")
                    }
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            //Show Alert
            self.present(alert, animated: true, completion: nil)
            
        }
        //Callback : Open Project
        if(message.name == "callbackOpen") {
            //Create Alert
            let alert = UIAlertController(
                title: "Open Project",
                message: "Do you Want to open '\(message.body)'?\nIf you don't save now project, it will be deleted",
                preferredStyle: .alert)
            
            //Button on Alert
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                let file_name = message.body
                print(file_name)
                if let dir = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask ).first {
                    
                    let path_file_name = dir.appendingPathComponent( file_name as! String )
                    
                    do {
                        
                        let intext = try String( contentsOf: path_file_name, encoding: String.Encoding.utf8 )
                        
                        print( intext )
                        self.webView.evaluateJavaScript("recieve_load(\(intext))") { (result, error) in
                            if error != nil {
                                print(result as Any)
                            }
                        }
                    } catch {
                        //Error
                    }
                }
                
                
                print("Send JS : mc_load()")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            //Show Alert
            self.present(alert, animated: true, completion: nil)
            
        }
        //Callback : Show local folder
        if(message.name == "callbackLoad") {
            Make_Lists()
        }
        //Callback : New Project
        if(message.name == "callbackNewgame") {
            print(message.body)
            //Create Alert
            let alert = UIAlertController(
                title: "New Project",
                message: "Do you start a new project?\nIf you don't save now project, it will be deleted",
                preferredStyle: .alert)
            
            //Button on Alert
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.webView.evaluateJavaScript("new_project(1)") { (result, error) in
                    if error != nil {
                        print(result as Any)
                    }
                }
                print("Send JS : new_project(1)")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            //Show Alert
            self.present(alert, animated: true, completion: nil)
            
            
            
        }
        //Callback : Save Masao JSON file
        if(message.name == "callbackHandler") {
            SaveAlert(altitle: "Save", almes: "Input file name *.json", altext: "supermasao", data: message.body)
        }
        
        //Callback : Read QR
        if(message.name == "callbackScan") {
            
            let targetViewController = self.storyboard!.instantiateViewController( withIdentifier: "qrreader" )
            self.present( targetViewController, animated: true, completion: nil)
            /*
            SimpleAlert(altitle: "Oops!", almes: "Sorry, scanning is not supported yet")
            */
            print("QR")
        }
        
        
    }
    //WKWebView
    var webView: WKWebView!
    
    override func loadView() {
        //WKWebView
        
        let contentController = WKUserContentController();
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = contentController
        //Config for connection with javascript
        contentController.add(self, name: "callbackLogin")
        contentController.add(self, name: "callbackHandler")
        contentController.add(self, name: "callbackNewgame")
        contentController.add(self, name: "callbackLoad")
        contentController.add(self, name: "callbackOpen")
        contentController.add(self, name: "callbackDeletefile")
        contentController.add(self, name: "callbackScan")
        contentController.add(self, name: "callbackCopy")
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
        webView.scrollView.bounces = false
        webView.allowsLinkPreview = false
        WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeDiskCache], modifiedSince: Date(timeIntervalSince1970: 0), completionHandler: {})
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let myurl = Bundle.main.url(forResource: "Main_html/index", withExtension: ".html")!
        let myRequest = URLRequest(url: myurl)
        webView.load(myRequest)
        
        //Request
        
    }
    
    //When backed here
    //
    //
    override func viewWillAppear(_ animated: Bool) {
        //Close if backed from QR reader
        if flag_qr2 == true{
            flag_qr2 = false
            print("Back!!!")
            print("\(str_qr1)")
            var ms_url = "\(str_qr1)"
            if let range = ms_url.range(of: "ms_app://") {
                ms_url.removeSubrange(range)
            }
            //Firebase config
            let storage = Storage.storage()
            let storageRef = storage.reference(forURL: "gs://beamasaoproducer.appspot.com/")
            let JsonRef = storageRef.child("GameDatas/\(ms_url).json")
            
            print("GameDatas/\(ms_url).json")
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            JsonRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if error != nil {
                    // Handle any errors
                    print("ERROR")
                    self.SimpleAlert(altitle: "Error", almes: "Couldn't find the game data.")
                } else {
                    // Data for "images/island.jpg" is returned
                    print("successed")
                    _ = "\(String(data: data!, encoding: .utf8)!)"
                    //print(j_data)
                    _ = "abc"
                    self.webView.evaluateJavaScript("MasaoJson(\(String(data: data!, encoding: .utf8)!))") { (result, error) in
                        if error != nil {
                            print(result as Any)
                        }
                    }
                    
                    
                    
                }
            }
            
            
            
        }
        
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        print("motionEnded - subtype: \(motion.rawValue) with \(String(describing: event))")
        if motion == UIEventSubtype.motionShake {
            print("Shaked")
            self.webView.evaluateJavaScript("Shaked()") { (result, error) in
                if error != nil {
                    print(result as Any)
                }
            }
            
        }
    }
    //Save file
    func Save_file(filename: String, data: Any){
        var file_name = filename
        let intext:String = data as! String //Data of JSON
        
        //Count String from File name
        let fn_c = file_name.count
        if fn_c < 5 {
            file_name = "\(file_name).json"
        } else {
            let fn = file_name.substring(from: file_name.index(file_name.endIndex, offsetBy: -5))
            if fn != ".json" {file_name = "\(file_name).json"}
        }
        //Check Files
        var Doc_files: [String] {
            do {
                return try FileManager.default.contentsOfDirectory(atPath: documentPath)
            } catch {
                return []
            }
        }
        if Doc_files.contains(file_name) == true {
            print("ファイル重複")
            let falert = UIAlertController(
                title: "Duplicated",
                message: "'\(file_name)' is duplicated\nDo you want to overwrite?",
                preferredStyle: .alert)
            
            //Put alert button
            falert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
                print("YES")
                if let dir = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask ).first {
                    let path_file_name = dir.appendingPathComponent( file_name )
                    
                    do {
                        //Write Data to document folder as a JSON file
                        try (intext as AnyObject).write( to: path_file_name, atomically: false, encoding: String.Encoding.utf8.rawValue )
                        print("Wrote:\(path_file_name)")
                        self.SimpleAlert(altitle: "Saved!",almes: "Game data")
                    } catch {
                        //ERROR
                        print("!ERROR!")
                        self.SimpleAlert(altitle: "ERROR",almes: "Couldn't save data.")
                    }
                }
                return
            }))
            falert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
                print("Cancel")
                return
            }))
            
            //Show alert
            self.present(falert, animated: true, completion: nil)
        }else {print("ファイルOK")
            if let dir = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask ).first {
                let path_file_name = dir.appendingPathComponent( file_name )
                
                do {
                    //Write Data to document folder as a JSON file
                    try (intext as AnyObject).write( to: path_file_name, atomically: false, encoding: String.Encoding.utf8.rawValue )
                    print("Wrote:\(path_file_name)")
                    SimpleAlert(altitle: "Saved!",almes: "Game data")
                } catch {
                    //ERROR
                    print("!ERROR!")
                    SimpleAlert(altitle: "ERROR",almes: "Couldn't save data.")
                }
            }
        }
        
        
        
    }
    //Show Save Alert
    func SaveAlert(altitle: String, almes: String, altext: String, data: Any){
        let svalert = UIAlertController(title: altitle, message: almes, preferredStyle: .alert)
        //Add button "OK"
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            let textField = svalert.textFields![0] as UITextField
            let file_n: String = textField.text!
            if file_n == "" {
                print("NO value")
                self.SimpleAlert(altitle: "ERROR",almes: "File name is empty")
                return
            }else {
                print("Call function Save_file")
                self.Save_file(filename: file_n, data: data)
            }
        })
        svalert.addAction(okAction)
        
        //Add button "Cancel"
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action:UIAlertAction!) -> Void in
            return
        })
        svalert.addAction(cancelAction)
        
        //Add Text field
        svalert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = altext
        })
        
        svalert.view.setNeedsLayout() //Insured
        //Show Alert
        self.present(svalert, animated: true, completion: nil)
    }
    
    //Simple Alert function
    func SimpleAlert(altitle: String, almes: String) {
        let alertController = UIAlertController(title: altitle,message: almes, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
            print("Alert showed")
        }
        alertController.addAction(okAction)
        present(alertController,animated: true,completion: nil)
        
    }
    //Make List function
    func Make_Lists(){
        var Doc_files: [String] {
            do {
                return try FileManager.default.contentsOfDirectory(atPath: documentPath)
            } catch {
                return []
            }
        }
        print(Doc_files)
        //let Doc_str = Doc_files.joined(separator: ",")
        self.webView.evaluateJavaScript("Make_Lists(\(Doc_files))") { (result, error) in
            if error != nil {
                print(result as Any)
            }
        }
        print("Send JS : Make_Lists() with data")
    }
}

