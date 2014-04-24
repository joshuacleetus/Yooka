//
//  YookaAppDelegate.m
//  Yooka
//
//  Created by Joshua Cleetus on 09/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaAppDelegate.h"
#import "YookaNewsFeedViewController.h"
#import "YookaHuntsViewController.h"
#import "YookaSearchViewController.h"
#import "YookaPostViewController.h"
#import "YookaProfileViewController.h"
#import <Foursquare2.h>
#import "YookaBackend.h"
#import <AsyncImageDownloader.h>
#import <Reachability.h>
#import "BDViewController.h"
#import "YookaSearchLandingViewController.h"
#import "UIImageView+WebCache.h"

@implementation YookaAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {

    
    [Foursquare2 setupFoursquareWithClientId:@"TBNYPZHHJSTCOB4DHWQDP1BWYOV21O1FFIIQJREBRN0YBIEW"
                                      secret:@"MX34Q4GOYVYAI1SNKESDV01RUVSBFF5VZWLKILQFATNV2ZBU"
                                 callbackURL:@"Yooka://foursquare"];
    
    (void) [[KCSClient sharedClient] initializeKinveyServiceForAppKey:@"kid_PPyANe0vzO"
                                                        withAppSecret:@"36d7e422ee3b4f93bef4259e79654045"
                                                         usingOptions:nil];
    
    //Start push service
    [KCSPush registerForPush];
    
    [KCSPing pingKinveyWithBlock:^(KCSPingResult *result) {
        if (result.pingWasSuccessful == YES){
            NSLog(@"Kinvey Ping Success");
            self.updateStore = [KCSLinkedAppdataStore storeWithOptions:@{
                                                                         KCSStoreKeyCollectionName : @"userPicture",
                                                                         KCSStoreKeyCollectionTemplateClass : [YookaBackend class]}];

        } else {
            
            NSLog(@"Kinvey Ping Failed");
        }
    }];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    _userEmail = [ud objectForKey:@"user_email"];
    
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"Found a cached session");
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"email",@"read_friendlists",@"user_location",@"user_birthday"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
        
        // If there's no cached session, we will show a login button
    } else {
        
        //        UIButton *fbloginButton = [self.yookaViewController fbBtn];
        //        [fbloginButton setTitle:@"Facebook" forState:UIControlStateNormal];
        
        if (_userEmail) {
            [self userLoggedIn];
        }else{
            
            YookaViewController* media = [[YookaViewController alloc] init];
            UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:media];
            self.window.rootViewController = navigation;
            self.window.backgroundColor = [UIColor whiteColor];
            [self.window makeKeyAndVisible];
            //        return YES;
            
        }
        
    }
        
    }else{
        
        YookaViewController* media = [[YookaViewController alloc] init];
        UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:media];
        self.window.rootViewController = navigation;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        
    }
    
    return YES;

}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
//        NSLog(@"Session opened");
        
        // Show the user the logged-in UI
//        NSLog(@"fb accesstoken = %@",[[[FBSession activeSession]accessTokenData]accessToken]);
        _accessToken = [[[FBSession activeSession]accessTokenData]accessToken];
        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 NSLog(@"username = %@",user.username);
                 NSLog(@"user email = %@",[user objectForKey:@"email"]);
                 _userName = user.username;
                 _userPicUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", _userName];
                 NSLog(@"user email = %@",_userPicUrl);

                 NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                 [ud setObject:_userPicUrl forKey:@"user_pic_url"];
                 _userFullName = user.name;
                 _userEmail = [user objectForKey:@"email"];
                 _fbuserName = user.username;
                 
                 [KCSUser loginWithSocialIdentity:KCSSocialIDFacebook
                                 accessDictionary:@{KCSUserAccessTokenKey : _accessToken}
                              withCompletionBlock:^(KCSUser *user, NSError *errorOrNil, KCSUserActionResult result) {
                                  if (errorOrNil != nil) {
                                      
                                      BOOL wasUserError = [[errorOrNil domain] isEqual:KCSUserErrorDomain];
                                      NSString* title = wasUserError ? NSLocalizedString(@"Invalid Credentials", @"credentials error title") : NSLocalizedString(@"An error occurred.", @"Generic error message");
                                      NSString* message = wasUserError ? NSLocalizedString(@"Wrong username or password. Please check and try again.", @"credentials error message") : [errorOrNil localizedDescription];
                                      UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                                                      message:message
                                                                                     delegate:self
                                                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                                            otherButtonTitles:nil];
                                      [alert show];
                                      
                                  }else{

                                      NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                                      [ud setObject:_userEmail forKey:@"user_email"];
                                      [ud setObject:_fbuserName forKey:@"fbuser_name"];
                                      [ud synchronize];
                                      NSArray* firstLastStrings = [_userFullName componentsSeparatedByString:@" "];
                                      NSString* firstName = [firstLastStrings objectAtIndex:0];
                                      NSString* lastName = [firstLastStrings objectAtIndex:1];
                                      [user setUsername:_userEmail];
                                      [user setGivenName:firstName];
                                      [user setSurname:lastName];
                                      [user setEmail:_userEmail];
                                      
                                      [user saveWithCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil){
                                          if (errorOrNil) {
//                                              NSLog(@"error = %@",errorOrNil);

                                          } else {
                                              
                                              NSLog(@"logged in");
                                              NSLog(@"kcsuser = %@",[KCSUser activeUser].username);
                                              [self saveUserImage];
                                              [self userLoggedIn];

                                          }
                                          
                                      }];

                                  }
                              }];
             }
         }];
        
        return;
    }
    
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
//        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
//        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
//                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        YookaViewController* media = [[YookaViewController alloc] init];
        UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:media];
        self.window.rootViewController = navigation;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
    }
}

// Show the user the logged-out UI
- (void)userLoggedOut
{
    // Set the button title as "Log in with Facebook"
//    UIButton *loginButton = [self.customLoginViewController loginButton];
//    [loginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
    
    
    YookaViewController* media = [[YookaViewController alloc] init];
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:media];
    self.window.rootViewController = navigation;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    // Confirm logout message
//    [self showMessage:@"You're now logged out" withTitle:@""];
    
}

// Show the user the logged-in UI
- (void)userLoggedIn
{
    // Set the button title as "Log out"
//    UIButton *loginButton = self.yookaViewController.loginButton;
//    [loginButton setTitle:@"Log out" forState:UIControlStateNormal];
//    YookaNewsFeedViewController* media = [[YookaNewsFeedViewController alloc]init];
//    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:media];
//    self.window.rootViewController = navigation;
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
//    return YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIViewController *viewController1 = [[YookaHuntsViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController1 = [[UINavigationController alloc]initWithRootViewController:viewController1];
    UIViewController *viewController2 = [[YookaNewsFeedViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController2 = [[UINavigationController alloc]initWithRootViewController:viewController2];
    UIViewController *viewController3 = [[YookaPostViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController3 = [[UINavigationController alloc]initWithRootViewController:viewController3];
    UIViewController *viewController4 = [[YookaSearchLandingViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController4 = [[UINavigationController alloc]initWithRootViewController:viewController4];
    UIViewController *viewController5 = [[BDViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController5 = [[UINavigationController alloc]initWithRootViewController:viewController5];

    // set the titles for the view controllers:
    viewController1.title = @"Hunts";
    viewController2.title = @"News Feed";
    viewController3.title = @"Upload Picture";
    viewController4.title = @"Search";
    viewController5.title = @"Profile";
    
    // set the images to appear in the tab bar:
    viewController1.tabBarItem.image = [UIImage imageNamed:@"hunt30x30.png"];
    viewController2.tabBarItem.image = [UIImage imageNamed:@"coin30x30.png"];
    viewController3.tabBarItem.image = [UIImage imageNamed:@"camera.png"];
    viewController4.tabBarItem.image = [UIImage imageNamed:@"search.png"];
    viewController5.tabBarItem.image = [UIImage imageNamed:@"user.png"];
    
    self.yookaTabBar = [[UITabBarController alloc] init];
    self.yookaTabBar.viewControllers = [NSArray arrayWithObjects:navController1,navController2,navController3,navController4,navController5, nil];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
//    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    //        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor], UITextAttributeTextColor, nil]
    //                                                 forState:UIControlStateNormal];
    self.window.rootViewController = self.yookaTabBar;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Welcome message
//    [self showMessage:@"WOO... You're now successfully logged in to Yooka" withTitle:@"Welcome!"];
    
}

// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}

// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
// Override application:openURL:sourceApplication:annotation to call the FBsession object that handles the incoming URL
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)saveUserImage
{

    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:_userPicUrl]
                                                        options:0
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
         // progression tracking code
     }
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (image && finished)
         {
        _userImage = image;
        [self saveUserImage2];
        
         }
     }];
    

}

- (void)saveUserImage2
{
    
        NSLog(@"save image");
        YookaBackend *yookaObject = [[YookaBackend alloc]init];
        yookaObject.kinveyId = _userEmail;
        if (_userImage) {
            yookaObject.userImage = _userImage;
        }else{
            yookaObject.userImage = [UIImage imageNamed:@"minion.jpg"];
        }
        yookaObject.userFullName = _userFullName;
        yookaObject.userEmail = _userEmail;
    NSLog(@"user full name = %@",_userFullName);
    NSLog(@"user email = %@",_userEmail);
    
    [yookaObject.meta setGloballyReadable:YES];
    [yookaObject.meta setGloballyWritable:YES];
    
        //Kinvey use code: add a new update to the updates collection
        [self.updateStore saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil == nil) {
                NSLog(@"saved successfully");
//                YookaAppDelegate* appDelegate = (id)[UIApplication sharedApplication].delegate;
//                [appDelegate userLoggedIn];
            } else {
                NSLog(@"save failed %@",errorOrNil);
            }
        } withProgressBlock:nil];
    
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[KCSPush sharedPush] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken completionBlock:^(BOOL success, NSError *error) {
        //if there is an error, try again laster
    }];
    // Additional registration goes here (if needed)
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[KCSPush sharedPush] application:application didReceiveRemoteNotification:userInfo];
    // Additional push notification handling code should be performed here
}
- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[KCSPush sharedPush] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[KCSPush sharedPush] registerForRemoteNotifications];
    //Additional become active actions
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    [[KCSPush sharedPush] onUnloadHelper];
    // Additional termination actions
}

@end
