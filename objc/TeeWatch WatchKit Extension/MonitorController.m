//
//  MonitorController.m
//  TeeWatch WatchKit Extension
//


#import "MonitorController.h"

@interface MonitorController()
@property (assign, nonatomic) BOOL waitingToMeasure;
@property (assign, nonatomic) BOOL showingMetricUnits;
@end

@implementation MonitorController

- (void)awakeWithContext:(id)context {
   [super awakeWithContext:context];
   
   // Configure interface objects here.
   self.waitingToMeasure = YES;
   [self preloadAudioFile: @"trombone.caf"];
}

- (void)willActivate {
   // This method is called when watch view controller is about to be visible to user
   [super willActivate];
   [self.imageView setAlpha: 0.0];
}

- (void)didAppear {
   [super didAppear];
}

- (void)didDeactivate {
   // This method is called when watch view controller is no longer visible
   [super didDeactivate];
   self.waitingToMeasure = YES;
   [self.imageView setImageNamed: @"frame_"];
}

- (IBAction)onButtonTapped {
   if (self.waitingToMeasure) {
      self.waitingToMeasure = NO;
      [self.imageView setAlpha: 1.0];
      [self.imageView setImageNamed: @"frame_"];
      NSTimeInterval animationDuration = 6.0;
      [self.imageView startAnimatingWithImagesInRange: NSMakeRange(0, 24) duration: animationDuration repeatCount: 2];
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self.imageView stopAnimating];
         [self showResults: YES];
      });
   } else {
      // results are being displayed
      NSString *title = self.showingMetricUnits ? @"English" : @"Metric";
      NSString *imgName = self.showingMetricUnits ? @"NaN" : @"NaNunits";
      [self.button setTitle: title];
      [self.imageView setImageNamed: imgName];
      self.showingMetricUnits = !self.showingMetricUnits;
   }
}

- (void)showResults: (BOOL)withClown {
   [self.imageView setImageNamed: @"NaN"];
   [self.button setTitle: @"English"];
   if (withClown) {
      [self say: @"Your T is not measurable. Please seek medical attention."];
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self.imageView setImageNamed: @"clown"];
         [self playAudioFileWithCompletionHandler:^{
            [self showResults: NO];
         }];       
      });
   }
}

@end
