//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Sai Vamsi Muvva on 5/17/16.
//  Copyright © 2016 Sai Vamsi Muvva. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController , AVAudioRecorderDelegate{

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder : AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: AnyObject) {
        print("Record Audio Clicked")
        recordingLabel.text = "Recording in progress"
        recordButton.enabled = false
        stopRecordingButton.enabled = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    @IBAction func stopRecording(sender: AnyObject) {
        print("Recording Stopped")
        recordingLabel.text = "Tap to Record"
        recordButton.enabled = true
        stopRecordingButton.enabled = false
        recordingLabel.text = "Tap to Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    override func viewWillAppear(animated: Bool) {
        print("ViewWillAppear called")
        stopRecordingButton.enabled = false
    }
    
    func audioRecorderDidFinishRecording(recorder : AVAudioRecorder , successfully flag: Bool){
        print("AVAudiorecorder finished recording")
        if(flag){
            self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        }
        else{
            print("Saving of recording failed")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! playSoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}


