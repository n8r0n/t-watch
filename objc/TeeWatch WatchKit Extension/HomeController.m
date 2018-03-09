//
//  HomeController.m
//  TeeWatch WatchKit Extension
//


#import "HomeController.h"
@import AVFoundation;

@interface HomeController ()
//@property (strong, nonatomic) WKAudioFilePlayer *player;
@property (assign, nonatomic) BOOL hasStartedAnimating;
@end


@implementation HomeController

- (void)awakeWithContext:(id)context {
   [super awakeWithContext:context];
   
   // Configure interface objects here.
   //WKAudioFileAsset *sound = [WKAudioFileAsset assetWithURL: soundURL];
   //WKAudioFilePlayerItem *item = [WKAudioFilePlayerItem playerItemWithAsset: sound];
   //self.player = [WKAudioFilePlayer playerWithPlayerItem: item];
   
   [self preloadAudioFile: @"pity.caf"];
   //[self.moviePlayer setMovieURL: [NSURL fileURLWithPath: path]];
   [self startAnimation];
}

- (void)didAppear {
   [super didAppear];
}

- (void)startAnimation {
   if (!self.hasStartedAnimating) {
      self.hasStartedAnimating = YES;
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self.imageView setImageNamed: @"mrTpointing"];
         //if (self.player.status == WKAudioFilePlayerStatusReadyToPlay) {
         //[self.moviePlayer playFromBeginning];
         [self playAudioFileWithCompletionHandler:^{
            [self say: @"who don't watch his T"];
            self.hasStartedAnimating = NO;
         }];
      });
   }
}

- (void)willActivate {
   // This method is called when watch view controller is about to be visible to user
   [super willActivate];
   [self startAnimation];
}

- (void)didDeactivate {
   // This method is called when watch view controller is no longer visible
   [super didDeactivate];
   [self.imageView setImageNamed: @"mrT"];
}

@end



