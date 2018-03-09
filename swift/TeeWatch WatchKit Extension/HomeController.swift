//
//  InterfaceController.swift
//  TeeWatch WatchKit Extension
//


import WatchKit
import Foundation


class HomeController: TeeBaseController {
   
   @IBOutlet var imageView: WKInterfaceImage!
   @IBOutlet var moviePlayer: WKInterfaceInlineMovie!
   private var hasStartedAnimating : Bool = false
   
   override func awake(withContext context: Any?) {
      super.awake(withContext: context)
      
      // Configure interface objects here.
      preloadAudioFile("pity.caf")
      startAnimation()
   }
   
   override func willActivate() {
      // This method is called when watch view controller is about to be visible to user
      super.willActivate()
      startAnimation()
   }
   
   override func didAppear() {
      super.didAppear()
   }
   
   override func didDeactivate() {
      // This method is called when watch view controller is no longer visible
      super.didDeactivate()
      self.imageView.setImageNamed("mrT")
   }
   
   private func startAnimation() {
      if (!self.hasStartedAnimating) {
         self.hasStartedAnimating = true
         DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(3000), execute: {
            self.imageView.setImageNamed("mrTpointing")
            self.playAudioFile (completionHandler: {
               self.say("who don't watch his T")
               self.hasStartedAnimating = false
            })
         })
      }
   }
}
