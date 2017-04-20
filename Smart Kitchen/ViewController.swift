//
//  ViewController.swift
//  Smart Kitchen
//
//  Created by Navdeesh Ahuja on 03/02/17.
//  Copyright © 2017 Navdeesh Ahuja. All rights reserved.
//

import UIKit
import Speech


class ViewController: UIViewController, SFSpeechRecognizerDelegate, UITextFieldDelegate {
    
    @IBOutlet var recipeNameTextField: UITextField!
    
    @IBOutlet var recordButton: UIButton!
    
    @IBOutlet var buttonMessage: UILabel!
    
    var keyboardShown = false
    
    var timer = Timer()
    
    let imagesName = ["mic", "mic1", "mic2", "mic3"]
    var currentImage = 0
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeNameTextField.delegate = self
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 102/255.0, green: 187/255.0, blue: 106/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization{
            (authStatus) in
            
            
            switch authStatus
            {
            case .authorized:
                print("Authorised")
                
            case .denied:
                print("User denied access to speech recognition")
                
            case .restricted:
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                print("Speech recognition not yet authorized")
                
            }
            
            
            
            }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        recipeNameTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        recipeNameTextField.resignFirstResponder()
    }
    
    func keyboardWillShow(_ notification:NSNotification)
    {
        if(keyboardShown)
        {
            return
        }
        
        if let keyboardSize = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? CGRect
        {
            let keyboardTopPoint = keyboardSize.minY - keyboardSize.height
            let spaceInBetween = keyboardTopPoint - getBottomOfCurrentTextField()
            if(spaceInBetween < 20)
            {
                self.view.frame.origin.y -= (abs(spaceInBetween) + 145 + recipeNameTextField.frame.height)
            }
            
        }
        keyboardShown = true
    }
    
    func getBottomOfCurrentTextField() -> CGFloat
    {
        if(recipeNameTextField.isFirstResponder)
        {
            return recipeNameTextField.frame.maxY
        }
        
        return -100
    }
    
    func keyboardWillHide()
    {
        self.view.frame.origin.y = 0
        keyboardShown = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func startRecording(_ sender: Any)
    {
        //ActivityViewIndicator.show(self.view, "Parsing")
        
        if audioEngine.isRunning {
            stopAnimating()
            audioEngine.stop()
            recognitionRequest?.endAudio()
            buttonMessage.text = "Click to listen"
        } else {
            buttonMessage.text = "Click to stop listening"
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(startAnimating), userInfo: nil, repeats: true)
            startRecording()
        }
    }
    
    func startAnimating()
    {
        currentImage = (currentImage + 1)%4
        recordButton.setImage(UIImage(named: imagesName[currentImage]), for: .normal)
        //print(currentImage)
    }
    
    func stopAnimating()
    {
        //print("stopped")
        timer.invalidate()
        currentImage = 0
        recordButton.setImage(UIImage(named: imagesName[currentImage]), for: .normal)
        
    }
    
    func startRecording()
    {
        if recognitionTask != nil
        {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do
        {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        }
        catch
        {
            print("Error Occurred 1")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode
            else
        {
            print("Error 2 Occurred")
            return
        }
        
        guard let recognitionRequest = recognitionRequest
            else
        {
            print("Error 3 Occurred")
            return
        }
        
        recognitionRequest.shouldReportPartialResults = false
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: {
        (result, error) in
            
            var isFinal = false
            
            if(result != nil)
            {
                self.recipeNameTextField.text = result?.bestTranscription.formattedString
                isFinal = true
            }
            
            if error != nil || isFinal
            {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                
            }
            
        })
    
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat, block: {
            (buffer, when) in
            
            self.recognitionRequest?.append(buffer)
            
        })
        
        audioEngine.prepare()
        
        do
        {
            try audioEngine.start()
        }
        catch
        {
            print("Error at 4")
        }
        
        recipeNameTextField.text = "Say Something I am listening"
    }
    
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            print("Available :)")
        } else {
            print("Not Available :(")
        }
    }
    @IBAction func goButtonDidPress(_ sender: Any)
    {
        if(recipeNameTextField.text != "")
        {
            Globals.query = recipeNameTextField.text!
            Globals.requestDone = false
            self.performSegue(withIdentifier: "recipeScreenSegue", sender: nil)
        }
    }

}

