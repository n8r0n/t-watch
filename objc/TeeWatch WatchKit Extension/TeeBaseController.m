//
//  TeeBaseController.m
//  TeeWatch WatchKit Extension
//


#import "TeeBaseController.h"

@interface TeeBaseController()
@property (strong, nonatomic) AVAudioPlayerNode *player;
@property (strong, nonatomic) AVAudioEngine *engine;
@property (strong, nonatomic) AVAudioFile *soundFile;
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;
@end

@implementation TeeBaseController

- (void) awakeWithContext:(id)context {
   [super awakeWithContext:context];
   self.synthesizer = [[AVSpeechSynthesizer alloc] init];
   self.synthesizer.delegate = self;
   
   NSError *error;
   [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &error];
   if (error) {
      NSLog(@"AVAudioSession setCategory ERROR: %@", error.localizedDescription);
   }
   [[AVAudioSession sharedInstance] setActive: YES error: &error];
   if (error) {
      NSLog(@"AVAudioSession setActive ERROR: %@", error.localizedDescription);
   }
}

- (void) didDeactivate {
   [super didDeactivate];
   [self.engine pause];
}

- (void) willActivate {
   [super willActivate];
   if (self.engine && !self.engine.isRunning) {
      NSError *error;
      [self.engine startAndReturnError: &error];
      if (error) {
         NSLog(@"Oops!");
      }
   }
}

- (void) preloadAudioFile:(NSString *)filename {
   NSString *soundPath = [[NSBundle mainBundle] pathForResource: filename ofType: nil];
   NSURL *soundURL = [NSURL fileURLWithPath: soundPath];
   self.player = [AVAudioPlayerNode new];
   self.engine = [AVAudioEngine new];
   [self.engine attachNode: self.player];
   AVAudioFormat *stereo = [[AVAudioFormat alloc] initStandardFormatWithSampleRate: 44100 channels: 2];
   [self.engine connect: self.player to: self.engine.mainMixerNode format: stereo];
   NSError *error;
   if (!self.engine.isRunning) {
      [self.engine startAndReturnError: &error];
      if (error) {
         NSLog(@"Oops!");
      }
   }
   self.soundFile = [[AVAudioFile alloc] initForReading: soundURL error: &error];
   if (error) {
      NSLog(@"Oops!");
   }
}

- (void) playAudioFileWithCompletionHandler:(AVAudioNodeCompletionHandler)completionHandler {
   if (!self.engine.isRunning) {
      NSError *error;
      [self.engine startAndReturnError: &error];
      if (error) {
         NSLog(@"Engine could not be restarted");
      }
   }
   [self.player scheduleFile: self.soundFile atTime: nil completionHandler: completionHandler];
   [self.player play];
}

#pragma mark - Speech

- (void) say: (NSString*)what {
   AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString: what];
   [self.synthesizer speakUtterance: utterance];
}

@end
