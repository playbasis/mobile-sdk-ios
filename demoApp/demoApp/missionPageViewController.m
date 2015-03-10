//
//  missionPageViewController.m
//  demoApp
//
//  Created by Playbasis on 2/16/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import "missionPageViewController.h"
#import "missionViewController.h"
#import "demoAppSettings.h"

@interface missionPageViewController ()

@end

@implementation missionPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = self;
    self.delegate = self;
    
    // load the quest information from the given quest-id set by previous view that initiates this view
    [[Playbasis sharedPB] questOfPlayer:USER questId:_questId andBlock:^(PBQuestOfPlayer_Response *quest, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"Begin loading of quest information to render missionViewController.");
            NSLog(@"%@", quest);
            
            // save quest
            quest_ = quest;
            
            if([quest_.quest.missions.missions count] > 0)
            {
                // set the initial first view controller
                missionViewController *viewController = [self viewControllerAtIndex:0];
                NSArray *viewControllers = [NSArray arrayWithObject:viewController];
                [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            }
            else
            {
                // alert that's there no available quests
                UIAlertView *popup = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"There's no available missions" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [popup show];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((missionViewController*) viewController).pageIndex;
    
    if((index == 0) || (index == NSNotFound))
    {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((missionViewController*) viewController).pageIndex;
    
    if(index == NSNotFound)
    {
        return nil;
    }
    
    index++;
    if(index == [quest_.quest.missions.missions count])
    {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        // go back
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (missionViewController*)viewControllerAtIndex:(NSUInteger)index
{
    if(([quest_.quest.missions.missions count] == 0) || (index >= [quest_.quest.missions.missions count]))
    {
        return nil;
    }
    
    // get mission at the specified index
    PBMission *mission = [quest_.quest.missions.missions objectAtIndex:index];
    
    // create a new view controller and pass suitable data
    missionViewController *contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"missionContentViewController"];
    contentViewController.pageIndex = index;
    contentViewController.questId = quest_.quest.questId;
    contentViewController.mission = mission;
    
    return contentViewController;
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [quest_.quest.missions.missions count];
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
