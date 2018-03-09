//
//  TeeBaseController.swift
//  TeeWatch WatchKit Extension
//


import WatchKit
import AVFoundation

class TeeBaseController: WKInterfaceController, AVSpeechSynthesizerDelegate {
   
   private var player : AVAudioPlayerNode?
   private var engine : AVAudioEngine?
   private var soundFile : AVAudioFile?
   private var synthesizer : AVSpeechSynthesizer = AVSpeechSynthesizer()
   
   override func awake(withContext context: Any?) {
      super.awake(withContext: context)
      self.synthesizer.delegate = self
      let session : AVAudioSession = AVAudioSession.sharedInstance()
      do {
         try session.setCategory(AVAudioSessionCategoryPlayback)
      } catch {
         print("AVAudioSession setCategory ERROR: \(error.localizedDescription)")
      }
      do {
         try session.setActive(true)
      } catch {
         print("AVAudioSession setActive ERROR: \(error.localizedDescription)")
      }
   }
   
   override func didDeactivate() {
      super.didDeactivate()
      self.engine?.pause()
   }
   
   override func willActivate() {
      super.willActivate()
      if ((self.engine != nil) && !(self.engine?.isRunning)!) {
         do {
            try self.engine?.start()
         } catch {
            print("Oops!")
         }
      }
   }
   
   internal func preloadAudioFile(_ filename: String) {
      let soundPath : String = Bundle.main.path(forResource: filename, ofType: nil)!
      let soundURL : URL = URL(fileURLWithPath: soundPath)
      self.player = AVAudioPlayerNode()
      self.engine = AVAudioEngine()
      self.engine?.attach(self.player!)
      let stereo : AVAudioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)!
      self.engine?.connect(self.player!, to: (self.engine?.mainMixerNode)!, format: stereo)
      if (!(self.engine?.isRunning)!) {
         do {
            try self.engine?.start()
         } catch {
            print("Oops!")
         }
      }
      do {
         try self.soundFile = AVAudioFile(forReading: soundURL)
      } catch {
         print("Oops!")
      }
   }
   
   internal func playAudioFile(completionHandler: @escaping AVAudioNodeCompletionHandler) {
      if (!(self.engine?.isRunning)!) {
         do {
            try self.engine?.start()
         } catch {
            print("Engine could not be restarted")
         }
      }
      self.player?.scheduleFile(self.soundFile!, at: nil, completionHandler: completionHandler)
      self.player?.play()
   }
   
   //MARK: - Speech
   
   internal func say(_ what: String) {
      let utterance : AVSpeechUtterance = AVSpeechUtterance(string: what)
      self.synthesizer.speak(utterance)
   }
}
