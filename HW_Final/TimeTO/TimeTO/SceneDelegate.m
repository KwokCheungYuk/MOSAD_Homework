#import "SceneDelegate.h"
#import "AppDelegate.h"
#import "HomepageController.h"
#import "TodoViewController.h"
#import "UNNotificationsManager.h"
#import "HomeViewController.h"
#import "FirstPageController.h"
@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    [UNNotificationsManager registerLocalNotification];
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.window.backgroundColor = [UIColor whiteColor];
    UITabBarController *tabVC = [[UITabBarController alloc]init];
    //倒数日
    HomepageController *homeVC = [[HomepageController alloc]init];
    UINavigationController *homeNVC = [[UINavigationController alloc]initWithRootViewController:homeVC];
    homeNVC.tabBarItem.title = @"";
    homeNVC.tabBarItem.image = [[UIImage imageNamed:@"日历2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
      
        homeNVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"日历.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //待办事项
    TodoViewController *waitForVC = [[TodoViewController alloc]init];
    UINavigationController *waitForNVC = [[UINavigationController alloc]initWithRootViewController:waitForVC];
    waitForNVC.tabBarItem.title = @"";
    waitForNVC.tabBarItem.image = [[UIImage imageNamed:@"待办事项2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
      
        waitForNVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"待办事项.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //历史上的今天
    FirstPageController *historyVC = [[FirstPageController alloc]init];
    UINavigationController *historyNVC = [[UINavigationController alloc]initWithRootViewController:historyVC];
    historyNVC.tabBarItem.title = @"";
    historyNVC.tabBarItem.image = [[UIImage imageNamed:@"星球2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
      
        historyNVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"星球.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //闹钟
    HomeViewController *alarmVC = [[UIStoryboard storyboardWithName:@"AlarmClock" bundle:nil] instantiateViewControllerWithIdentifier:@"AlarmClockHome"];
    UINavigationController *alarmNVC = [[UINavigationController alloc]initWithRootViewController:alarmVC];
    alarmVC.tabBarItem.title = @"";
    alarmVC.tabBarItem.image = [[UIImage imageNamed:@"闹钟2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
      
        alarmVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"闹钟.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    tabVC.viewControllers = @[homeNVC, waitForNVC, historyNVC, alarmVC];
    [self.window setRootViewController:tabVC];
    [self.window makeKeyAndVisible];
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.

    // Save changes in the application's managed object context when the application transitions to the background.
    [(AppDelegate *)UIApplication.sharedApplication.delegate saveContext];
}


@end
