#import "RNInAppReviewIOS.h"
#import <StoreKit/SKStoreReviewController.h>

@implementation RNInAppReviewIOS


- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

- (NSDictionary *)constantsToExport
{
  return @{
    @"isAvailable": [SKStoreReviewController class] ? @(YES) : @(NO)
  };
}

RCT_EXPORT_METHOD(requestReview:
    resolver:(RCTPromiseResolveBlock)resolve
    rejecter:(RCTPromiseRejectBlock)reject) {
      // requestReview is deprecated in iOS 14.0+
      // https://stackoverflow.com/a/63954318/1159534
      if (@available(iOS 14.0, *)) {
        UIWindowScene *activeScene;
        NSSet *scenes = [[UIApplication sharedApplication] connectedScenes];
        for (UIScene *scene in scenes) {
          if ([scene activationState] == UISceneActivationStateForegroundActive) {
            activeScene = (UIWindowScene *)scene;
            break;
          }
        }
        if (activeScene != nil) {
          [SKStoreReviewController requestReviewInScene:activeScene];
        }
         resolve(@"true");
      } else if (@available(iOS 10.3, *)) {
        [SKStoreReviewController requestReview];
         resolve(@"true");
      }else{
         reject(@"21",@"ERROR_DEVICE_VERSION",nil);
      }
}

+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

@end
