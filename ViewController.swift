//
//  ViewController.swift
//  MasaoProducer
//
//  Created by 松田哲弥 on 2017/09/28.
//  Copyright © 2017年 Terry. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation
import Firebase
import CoreImage

var flag_qr1: Bool = false
var flag_qr2: Bool = false
var flag_ac1: Bool = false
var str_qr1:String = "nnn" //Data read from QR
var str_qr2:String = "nnn" //Data to QR
var str_qr3:String = "nnn" //Data to QR
var str_name:String = "nnn"
var str_title:String = "nnn"
var str_qrc:String = "nnn"


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


class qr_controller: UIViewController {
    
    @IBOutlet weak var qrimage: UIImageView!
    @IBOutlet weak var btn_cancel: UIButton!
    
    @IBOutlet weak var btn_dl: UIButton!
    // Set Portrait
    override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        createQR(url: "ms_app://\(str_qr3)")

        
    }
    @IBAction func Event_dl(_ sender: Any) {
        let pngImageData = UIImagePNGRepresentation(qrimage.image!)
        let image = UIImage(data: pngImageData!)
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        let alertController = UIAlertController(title: "Saved",message: "カメラロールに保存しました", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
            print("Alert showed")
        }
        alertController.addAction(okAction)
        self.present(alertController,animated: true,completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createQR(url: String){
        
        // NSString to NSData
        let data = url.data(using: String.Encoding.utf8)!
        
        let qr = CIFilter(name: "CIQRCodeGenerator", withInputParameters: ["inputMessage": data, "inputCorrectionLevel": "Q"])!
        
        
        let sizeTransform = CGAffineTransform(scaleX: 10, y: 10)
        let qrData = qr.outputImage!.applying(sizeTransform)
        
        let context = CIContext()
        let cgImage = context.createCGImage(qrData, from: qrData.extent)
        let qr_uiImage = UIImage(cgImage: cgImage!)
        
        // Create UIImage
        let msImage = UIImage(named: "Main_html/ms_img/masao.png")
        let msImage2 = UIImage(named: "Main_html/ms_img/masaoqr_base.png")
        
        let output_size = 500
        let image_size = 380
        let image_center_size = 86
        
        var newSize = CGSize(width:image_size, height:image_size)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, qr_uiImage.scale)
        
        qr_uiImage.draw(in: CGRect(x:0,y:0,width:image_size,height:image_size))
        
        msImage?.draw(in: CGRect(x:image_size / 2 - image_center_size / 2,y:image_size / 2 - image_center_size / 2,width:image_center_size,height:image_center_size),blendMode:CGBlendMode.normal, alpha:1.0)
        
        let newImage1:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext() // Generate QR code & Masao icon
        
        newSize = CGSize(width:output_size, height:output_size)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, (msImage2?.scale)!)
        
        msImage2?.draw(in: CGRect(x:0,y:0,width:output_size,height:output_size))
        
        newImage1.draw(in: CGRect(x:output_size / 2 - image_size / 2,y:output_size / 2 - image_size / 2,width:image_size,height:image_size),blendMode:CGBlendMode.normal, alpha:1.0)
        
        let newImage2:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        qrimage.image = newImage2
        
        //qrimage.image = uiImage
        
        print("QR is generated.")
        
    }
    
    @IBAction func Event_cencel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

class LoginScreen: UIViewController {
    var ref: DatabaseReference!
    
    @IBOutlet weak var input_email: UITextField!
    @IBOutlet weak var input_pw: UITextField!
    @IBOutlet weak var btn_signup: UIButton!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var btn_cancel: UIButton!
    
    @IBOutlet weak var load1: UIActivityIndicatorView!
    // Set Portrait
    override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    // Event SignUp Button
    @IBAction func Event_signup(_ sender: Any) {
        let targetViewController = self.storyboard!.instantiateViewController( withIdentifier: "signup" )
        targetViewController.modalTransitionStyle = .flipHorizontal
        self.present(targetViewController, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if flag_ac1 == true {
            self.dismiss(animated: true, completion: nil)
            flag_ac1 = false
        }
    }
    @IBAction func Event_login(_ sender: Any) {
        self.load1.isHidden = false
        let em = input_email.text!
        let pw = input_pw.text!
        btn_signup.isEnabled = false
        btn_login.isEnabled = false
        input_email.isEnabled = false
        input_pw.isEnabled = false
        Auth.auth().signIn(withEmail: em, password: pw) { (user, error) in
            if let error = error {
                self.load1.isHidden = true
                print("Login failed! \(error)")
                self.btn_signup.isEnabled = true
                self.btn_login.isEnabled = true
                self.input_email.isEnabled = true
                self.input_pw.isEnabled = true
                
                let alertController = UIAlertController(title: "Error",message: "\(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
                    print("Alert showed")
                }
                alertController.addAction(okAction)
                self.present(alertController,animated: true,completion: nil)
                
                return
            }
            self.load1.isHidden = true
            self.btn_signup.isEnabled = true
            self.btn_login.isEnabled = true
            self.input_email.isEnabled = true
            self.input_pw.isEnabled = true
            print("Logined")
            self.dismiss(animated: true, completion: nil)
            // ...
        }
    }
    @IBAction func Event_cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

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
            // If can launch camera
            // Creating Session
            let session = AVCaptureSession()
            flag_qr1 = true
            // Define capture device
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
            // Reset size of preview layer
            Reset_videoView()
            // Set video preview layer
            view.layer.addSublayer(video)
            session.startRunning()
            
        } else{
            print("permission error")
            camera_c = false
        }
        // Do any additional setup after loading the view, typically from a nib.

        // Create status bar
        rect1.frame = CGRect(x:0,y:0,width:self.view.bounds.width,height:20)
        rect1.backgroundColor = #colorLiteral(red: 0.391697526, green: 0.7094672322, blue: 0.9616494775, alpha: 1)
        self.view.addSubview(rect1)
        
        // Cancel button
        btn1_qr.addTarget(self, action: #selector(btn1_qr_Event(sender:)), for: .touchUpInside)
        self.view.bringSubview(toFront: btn1_qr)
        
    }
    // Click on Cancel button
    func btn1_qr_Event(sender: UIButton) {
        print("Pushed Cancel button")
        flag_qr1 = false
        flag_qr2 = false
        str_qr1 = "nnn"
        self.dismiss(animated: true, completion: nil)
    }
    // Capture QR
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
    // Detect device direction
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.onOrientationChange(notification:)),name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    // Reset preview layer
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
    // Redraw after detect direction
    func onOrientationChange(notification: NSNotification){
        Reset_videoView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Simple Alert function
    func SimpleAlert(altitle: String, almes: String) {
        let alertController = UIAlertController(title: altitle,message: almes, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
            print("Alert showed")
        }
        alertController.addAction(okAction)
        present(alertController,animated: true,completion: nil)
        
    }
}
// Create a new account
class SignupController: UIViewController {
    var ref: DatabaseReference!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var input_email: UITextField!
    @IBOutlet weak var input_pw: UITextField!
    @IBOutlet weak var input_name: UITextField!
    @IBOutlet weak var btn_signup: UIButton!
    
    @IBOutlet weak var load1: UIActivityIndicatorView!
    
    // Set Portrait
    override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Event_cancel(_ sender: Any) {
        flag_ac1 = true
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func Event_signup(_ sender: Any) {
        
        let em = input_email.text!
        let pw = input_pw.text!
        let name = input_name.text!
        if(em == "" || pw == "" || name == ""){
            let alertController = UIAlertController(title: "Error",message: "入力欄に不備があります", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
                print("Alert showed")
            }
            alertController.addAction(okAction)
            self.present(alertController,animated: true,completion: nil)
            
        }else {
            self.load1.isHidden = false
            newac(em: em, pw: pw, name: name)
            
        }
        
        
    }
    
    func newac(em: String, pw: String, name: String){
        Auth.auth().createUser(withEmail: em, password: pw) { (user, error) in
            if let error = error {
                self.load1.isHidden = true
                print("Creating the user failed! \(error)")
                self.btn_signup.isEnabled = true
                self.input_email.isEnabled = true
                self.input_pw.isEnabled = true
                self.input_name.isEnabled = true
                let alertController = UIAlertController(title: "Error",message: "\(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
                    print("Alert showed")
                }
                alertController.addAction(okAction)
                self.present(alertController,animated: true,completion: nil)
                
                return
            }
            if let user = user {
                self.load1.isHidden = true
                print("user : \(String(describing: user.email)) has been created successfully.")
                self.ref.child("users/\(user.uid)/qrc").setValue("5")
                self.ref.child("users/\(user.uid)/name").setValue("\(name)")
                self.ref.child("name_lists/\(name)").setValue(1)
                let AC_alert = UIAlertController(title: "MasaoApp",message: "アカウントが作成されました", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
                    print("Created Account")
                    flag_ac1 = true
                    self.dismiss(animated: true, completion: nil)
                    
                }
                AC_alert.addAction(okAction)
                self.present(AC_alert,animated: true,completion: nil)
                
            }
        }
        
    }
    
}

// MasaoApp main UI
class ViewController2: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    var ref: DatabaseReference!
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name)
        if(message.name == "callbackLogin") {
            print(message.body)
            // Check Logined or not
            if Auth.auth().currentUser != nil {
                
                print("User is signed in.")
                
                accountarea(open_c: 0)
                
                // ...
            } else {
                print("No user is signed in.")
                
                let targetViewController = self.storyboard!.instantiateViewController( withIdentifier: "loginpage" )
                self.present( targetViewController, animated: true, completion: nil)
            }
            
        }
        
        if(message.name == "callbackLogout") {
            do {
                try Auth.auth().signOut()
                print("signout")
                self.webView.evaluateJavaScript("tab_back(0)") { (result, error) in
                    if error != nil {
                        print(result as Any)
                    }
                }
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
                self.SimpleAlert(altitle: "Error", almes: "ログアウトできませんでした")
            }

        }
        if(message.name == "callbackShare") {
            // title, id
            var body : [String]
            body = message.body as! [String]
            str_qr2 = body[0]
            str_qr3 = body[1]
            let targetViewController = self.storyboard!.instantiateViewController( withIdentifier: "qrgen" )
            self.present( targetViewController, animated: true, completion: nil)
            
        }
        
        if(message.name == "callbackInputTitle") {
            let mes_title = "シェア"
            let mes_body = "現在開いているステージをMasaoQRで共有します。"
            let alert = UIAlertController(title: mes_title, message: mes_body, preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField:UITextField) -> Void in
                //            textField.text = "default text."
                textField.placeholder = "Stage Title"
            })
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) -> Void in
                let textField = alert.textFields![0] as UITextField
                //タイトル入力後
                str_title = "\(textField.text!)"
                self.webView.evaluateJavaScript("Swift_Up('\(textField.text!)','\(str_name)')") { (result, error) in
                    if error != nil {
                        print(result as Any)
                    }
                    
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action:UIAlertAction) -> Void in
                print("Cancel")
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        if(message.name == "callbackUpload") {
            
            // Create game id
            let now = NSDate()
            let formatter = DateFormatter()
            formatter.dateFormat = "SSSssmmHHMMdd"
            let num_forid = formatter.string(from: now as Date)
            let game_int = Int(num_forid)!

            let formatter2 = DateFormatter()
            formatter2.dateFormat = "yyyy"
            let num_forid2 = formatter2.string(from: now as Date)
            var game_int2 = Int(num_forid2)!
            game_int2 = game_int2 - 2000
            print(game_int)
            let randomString = randomStr(length: 5)
            print(game_int2)
            print(randomString)
            let str_forid = "\(randomString)\(game_int)\(Int.init(arc4random_uniform(10)))"
            print(str_forid)
            let b64: Data = str_forid.data(using: .utf8)!
            var game_id = "\(b64.base64EncodedString())"
            if let range = game_id.range(of: "=") {
                game_id.removeSubrange(range)
            }
            if let range = game_id.range(of: "=") {
                game_id.removeSubrange(range)
            }
            let game_title = str_title
            // Data in memory
            let data = "\(message.body)".data(using: .utf8)!
            
            // Create a reference to the file you want to upload
            let storage = Storage.storage()
            let storageRef = storage.reference(forURL: "gs://beamasaoproducer.appspot.com/")
            let userID = Auth.auth().currentUser?.uid
            
            let riversRef = storageRef.child("GameDatas/\(game_id).json")
            
            // Upload the JSON file
            let uploadTask = riversRef.putData(data, metadata: nil)
                uploadTask.observe(.success) { snapshot in
                    self.ref.child("users/\(userID!)/games/\(game_title)").setValue("\(game_id)")
                    print("Uploaded")
                    self.SimpleAlert(altitle: "アップロードが完了しました", almes: "MasaoQRでステージを共有できます。")
                    self.accountarea(open_c: 1)

                }
            // Failure
            uploadTask.observe(.failure) { snapshot in
                if (snapshot.error as NSError?) != nil {
                    print("Error")
                    self.SimpleAlert(altitle: "Error", almes: "アップロードエラーが発生しました。")
                }
            }

        }
        
        if(message.name == "callbackDeleteQR") {
            // title, id
            var body : [String]
            body = message.body as! [String]
            // Create Alert
            let alert = UIAlertController(
                title: "\(body[0])",
                message: "ステージ「\(body[0])」を削除しますか？?\nこの操作は元に戻せません",
                preferredStyle: .alert)
            
            // Button on Alert
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                // Create a reference to the file to delete
                //Firebase config
                let storage = Storage.storage()
                let storageRef = storage.reference(forURL: "gs://beamasaoproducer.appspot.com/")
                let desertRef = storageRef.child("GameDatas/\(body[1]).json")
                
                // Delete the file
                desertRef.delete { error in
                    if error != nil {
                        // Uh-oh, an error occurred!
                    } else {
                        // File deleted successfully
                        let userID = Auth.auth().currentUser?.uid
                        if userID != nil{
                            self.ref.child("users/\(userID!)/games/\(body[0])").setValue(nil)
                            self.accountarea(open_c: 1)
                            
                        }
                    }
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            // Show Alert
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
        if(message.name == "callbackCopy") {
            let board = UIPasteboard.general
            board.string = "\(message.body)"
            SimpleAlert(altitle: "コピー完了", almes: "HTMLデータをクリップボードにコピーしました。")
        }
        // Callback : Delete Project
        if(message.name == "callbackDeletefile") {
            //Create Alert
            let alert = UIAlertController(
                title: "Delete Project",
                message: "ステージ「\(message.body)」を削除しますか？\nこの操作は元に戻せません。",
                preferredStyle: .alert)
            
            // Button on Alert
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
        // Callback : Open Project
        if(message.name == "callbackOpen") {
            // Create Alert
            let alert = UIAlertController(
                title: "Open Project",
                message: "ファイル「\(message.body)」を開きますか？\nセーブされていない編集中のデータは削除されます。",
                preferredStyle: .alert)
            
            // Button on Alert
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
                        // Error
                    }
                }
                
                
                print("Send JS : mc_load()")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            // Show Alert
            self.present(alert, animated: true, completion: nil)
            
        }
        // Callback : Show local folder
        if(message.name == "callbackLoad") {
            Make_Lists()
        }
        // Callback : New Project
        if(message.name == "callbackNewgame") {
            print(message.body)
            //Create Alert
            let alert = UIAlertController(
                title: "New Project",
                message: "新規ステージを作成しますか？?\nセーブされていない編集中のデータは削除されます",
                preferredStyle: .alert)
            
            // Button on Alert
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
        // Callback : Save Masao JSON file
        if(message.name == "callbackHandler") {
            SaveAlert(altitle: "Save", almes: "Input file name *.json", altext: "ファイル名を入力してください。", data: message.body)
        }
        
        // Callback : Read QR
        if(message.name == "callbackScan") {
            
            let targetViewController = self.storyboard!.instantiateViewController( withIdentifier: "qrreader" )
            self.present( targetViewController, animated: true, completion: nil)
            /*
            SimpleAlert(altitle: "Oops!", almes: "Sorry, scanning is not supported yet")
            */
            print("QR")
        }
        
        
    }
    // WKWebView
    var webView: WKWebView!
    
    override func loadView() {
        // WKWebView
        
        let contentController = WKUserContentController();
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = contentController
        // Config for connection with javascript
        contentController.add(self, name: "callbackLogin")
        contentController.add(self, name: "callbackLogout")
        contentController.add(self, name: "callbackUpload")
        contentController.add(self, name: "callbackShare")
        contentController.add(self, name: "callbackDeleteQR")
        contentController.add(self, name: "callbackHandler")
        contentController.add(self, name: "callbackNewgame")
        contentController.add(self, name: "callbackLoad")
        contentController.add(self, name: "callbackOpen")
        contentController.add(self, name: "callbackDeletefile")
        contentController.add(self, name: "callbackScan")
        contentController.add(self, name: "callbackCopy")
        contentController.add(self, name: "callbackInputTitle")
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
        
        // Request
        ref = Database.database().reference()
        
    }
    

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
                    self.SimpleAlert(altitle: "Error", almes: "ゲームデータが取得できませんでした\n存在しないか削除された可能性があります。")
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

    func randomStr(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    // Account Controller
    func accountarea(open_c: Int){
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            var send_lst1 = ""
            var send_lst2 = ""
            // Get user value
            let value = snapshot.value as? NSDictionary
            let qrc = value?["qrc"] as? String ?? ""
            let name = value?["name"] as? String ?? ""
            str_name = name
            str_qrc = qrc
            let games = value?["games"] as? NSDictionary
            if games != nil {
                for (key, value) in games! {
                    print("\(key) -> \(value)")
                    if send_lst1 != "" {
                        send_lst1 = send_lst1 + ","
                        send_lst2 = send_lst2 + ","
                    }
                    send_lst1 = send_lst1 + "\"\(key)\""
                    send_lst2 = send_lst2 + "\"\(value)\""
                }
            }
            
            let intext1 = "\(send_lst1)"
            let intext2 = "\(send_lst2)"
            self.webView.evaluateJavaScript("accountarea([\(intext1)],[\(intext2)],'\(qrc)','\(open_c)','\(name)')") { (result, error) in
                if error != nil {
                    print(result as Any)
                }
                print(intext1 + "\n" + intext2)
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
            self.SimpleAlert(altitle: "Error", almes: "unknown")
        }
    }
    
    func ac_make_id(){
        // Alert included Textfield
        let alert = UIAlertController(title: "ユーザー名", message: "ユーザー名を作成してください", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            if let textFields = alert.textFields {
                for textField in textFields {
                    print(textField.text!)
                }
            }
        })
        alert.addAction(okAction)
        
        // Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "Display name"
        })
        alert.view.setNeedsLayout()
        
        // Show alert
        self.present(alert, animated: true, completion: nil)
        
        return
    }
    
    // Save file
    func Save_file(filename: String, data: Any){
        var file_name = filename
        let intext:String = data as! String //Data of JSON
        
        // Count String from File name
        let fn_c = file_name.count
        if fn_c < 5 {
            file_name = "\(file_name).json"
        } else {
            let fn = file_name.substring(from: file_name.index(file_name.endIndex, offsetBy: -5))
            if fn != ".json" {file_name = "\(file_name).json"}
        }
        // Check Files
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
                message: "「\(file_name)」は既に存在します\n上書きしてもよろしいですか？",
                preferredStyle: .alert)
            
            // Put alert button
            falert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
                print("YES")
                if let dir = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask ).first {
                    let path_file_name = dir.appendingPathComponent( file_name )
                    
                    do {
                        // Write Data to document folder as a JSON file
                        try (intext as AnyObject).write( to: path_file_name, atomically: false, encoding: String.Encoding.utf8.rawValue )
                        print("Wrote:\(path_file_name)")
                        self.SimpleAlert(altitle: "Saved!",almes: "保存されました")
                    } catch {
                        //ERROR
                        print("!ERROR!")
                        self.SimpleAlert(altitle: "ERROR",almes: "保存できませんでした")
                    }
                }
                return
            }))
            falert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
                print("Cancel")
                return
            }))
            
            // Show alert
            self.present(falert, animated: true, completion: nil)
        }else {print("ファイルOK")
            if let dir = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask ).first {
                let path_file_name = dir.appendingPathComponent( file_name )
                
                do {
                    // Write Data to document folder as a JSON file
                    try (intext as AnyObject).write( to: path_file_name, atomically: false, encoding: String.Encoding.utf8.rawValue )
                    print("Wrote:\(path_file_name)")
                    SimpleAlert(altitle: "Saved!",almes: "保存されました")
                } catch {
                    //ERROR
                    print("!ERROR!")
                    SimpleAlert(altitle: "ERROR",almes: "保存できませんでした")
                }
            }
        }
        
        
        
    }
    // Show Save Alert
    func SaveAlert(altitle: String, almes: String, altext: String, data: Any){
        let svalert = UIAlertController(title: altitle, message: almes, preferredStyle: .alert)
        // Add button "OK"
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            let textField = svalert.textFields![0] as UITextField
            let file_n: String = textField.text!
            if file_n == "" {
                print("NO value")
                self.SimpleAlert(altitle: "ERROR",almes: "ファイル名が入力されていません")
                return
            }else {
                print("Call function Save_file")
                self.Save_file(filename: file_n, data: data)
            }
        })
        svalert.addAction(okAction)
        
        // Add button "Cancel"
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action:UIAlertAction!) -> Void in
            return
        })
        svalert.addAction(cancelAction)
        
        // Add Text field
        svalert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = altext
        })
        
        svalert.view.setNeedsLayout() // Insured
        // Show Alert
        self.present(svalert, animated: true, completion: nil)
    }
    
    // Simple Alert function
    func SimpleAlert(altitle: String, almes: String) {
        let alertController = UIAlertController(title: altitle,message: almes, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
            print("Alert showed")
        }
        alertController.addAction(okAction)
        present(alertController,animated: true,completion: nil)
        
    }
    // Make List function
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

