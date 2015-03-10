//
//  questPageViewController.m
//  demoApp
//
//  Created by Playbasis on 2/6/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import "questPageViewController.h"
#import "questDemoViewController.h"
#import "Playbasis.h"
#import "demoAppSettings.h"
#import "globalCaching.h"

@interface questPageViewController ()

- (void)prepareAllRewardsLinesForAllQuestsFrom:(NSArray *)questBasics;
- (void)setViewsForSelf;

@end

@implementation questPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = self;
    self.delegate = self;
    
    // show blank view ui controller before doing any loading
    // we will set viewControllers again after we finished loading requested information
    UIViewController *blankView = [self.storyboard instantiateViewControllerWithIdentifier:@"blankViewUIController"];
    NSArray *viewControllers = [NSArray arrayWithObject:blankView];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    _allRewardsLinesForAllQuests = [NSMutableArray array];
    
    // show hud (spining activity indicator)
    [[Playbasis sharedPB] showHUDFromView:self.view withText:@"Loading"];
    
    // make requests only when network is reachable
    if([Playbasis sharedPB].isNetworkReachable)
    {
        // create empty array
        _questImages = [NSMutableDictionary dictionary];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // load all quests available to player
            [[Playbasis sharedPB] questListAvailableForPlayer:USER withBlock:^(PBQuestListAvailableForPlayer_Response *list, NSURL *url, NSError *error) {
                if(!error)
                {
                    // save the response
                    _questListAvailable = list;
                    // update to globalCaching
                    [globalCaching sharedInstance].cachedQuestListAvailable_response = _questListAvailable;
                    
                    // async load all image from the quest-list
                    for(PBQuestBasic *q in _questListAvailable.list.questBasics)
                    {
                        // load image in blocking-call
                        [UIImage startLoadingImageWithUrl:q.image response:^(UIImage *image) {
                            [_questImages setValue:image forKey:q.questId];
                        }];
                        // update to globalCaching
                        [globalCaching sharedInstance].cachedQuestImages = _questImages;
                    }
                    
                    // prepare all rewards-line for all quests
                    [self prepareAllRewardsLinesForAllQuestsFrom:_questListAvailable.list.questBasics];
                    
                    // load quest that player has joined to get its status
                    [[Playbasis sharedPB] questListOfPlayer:USER withBlock:^(PBQuestListOfPlayer_Response *questList, NSURL *url, NSError *error) {
                        if(!error)
                        {
                            // save the result
                            _questList = questList;
                            // update to globalCaching
                            [globalCaching sharedInstance].cachedQuestListOfPlayer_response = _questList;
                            
                            NSLog(@"Complete loading all quests information.");
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                // if there's no available quests to show
                                if(_questListAvailable.list.questBasics == nil ||
                                   [_questListAvailable.list.questBasics count] == 0)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network error!" message:@"Cannot load data" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                                // otherwise set views to show
                                else
                                {
                                    // set views for self
                                    [self setViewsForSelf];
                                    // hide hud
                                    [[Playbasis sharedPB] hideHUDFromView:self.view];
                                }
                            });
                        }
                        else
                        {
                            NSLog(@"Error request to questListOfPlayer %@", error);
                        }
                    }];
                }
                else
                {
                    NSLog(@"Error request to questListAvailableForPlayer %@", error);
                }
            }];
        });
    }
    // otherwise we use cached data if it's ready to use
    else if([globalCaching sharedInstance].questDataReadyToUse)
    {
        // all cached data set then populate view for this pageview
        NSLog(@"Use cached data");
        
        // get cached data from globalCaching
        _questListAvailable = [globalCaching sharedInstance].cachedQuestListAvailable_response;
        _questList = [globalCaching sharedInstance].cachedQuestListOfPlayer_response;
        _questImages = [globalCaching sharedInstance].cachedQuestImages;
        
        // prepare all rewards-line for all quests
        [self prepareAllRewardsLinesForAllQuestsFrom:_questListAvailable.list.questBasics];
        
        // set views for self
        [self setViewsForSelf];
        
        // hide hud
        [[Playbasis sharedPB] hideHUDFromView:self.view];
    }
    // network is not reachable, and cached data is not ready
    // thus we show alert and go back to mainmenu
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network error!" message:@"Cannot load data" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setViewsForSelf
{
    // set the initial first view controller
    questDemoViewController *viewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:viewController];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // set the current page index for later use when we touch the button
    currentPageIndex = 0;
}

- (void)prepareAllRewardsLinesForAllQuestsFrom:(NSArray *)questBasics
{
    // iterate PBQuestBasis from the input array
    for(PBQuestBasic *q in questBasics)
    {
        if([q.rewards.rewards count] > 0)
        {
            NSMutableString *rewardsLines = [NSMutableString string];
            
            for(PBReward *reward in q.rewards.rewards)
            {
                NSString *rewardValue = reward.rewardValue;
                
                if(reward.rewardName != nil)
                {
                    // form the line
                    NSString *line = [NSString stringWithFormat:@"%@: %@", reward.rewardName, rewardValue];
                    
                    // append to the result string
                    if([rewardsLines length] == 0)
                        rewardsLines = [NSMutableString stringWithFormat:@"%@%@", rewardsLines, line];
                    else
                        rewardsLines = [NSMutableString stringWithFormat:@"%@\n%@", rewardsLines, line];
                }
                else
                {
                    // form the line (without reward name)
                    NSString *line = [NSString stringWithFormat:@"Unknown type: %@", rewardValue];
                    
                    // append to the result string
                    if([rewardsLines length] == 0)
                        rewardsLines = [NSMutableString stringWithFormat:@"%@%@", rewardsLines, line];
                    else
                        rewardsLines = [NSMutableString stringWithFormat:@"%@\n%@", rewardsLines, line];
                }
            }
            
            // add to array
            [_allRewardsLinesForAllQuests addObject:rewardsLines];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        // go back
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((questDemoViewController*) viewController).pageIndex;
    
    if((index == 0) || (index == NSNotFound))
    {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((questDemoViewController*) viewController).pageIndex;
    
    if(index == NSNotFound)
    {
        return nil;
    }
    
    index++;
    if(index == [_questListAvailable.list.questBasics count])
    {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (questDemoViewController*)viewControllerAtIndex:(NSUInteger)index
{
    if(([_questListAvailable.list.questBasics count] == 0) || (index >= [_questListAvailable.list.questBasics count]))
    {
        return nil;
    }
    
    // get quest basic
    PBQuestBasic *questBasic = [_questListAvailable.list.questBasics objectAtIndex:index];
    
    // get quest at the specified index
    NSString *status = nil;
    
    if(_questList.questList.quests != nil )
    {
        for(PBQuest *quest in _questList.questList.quests)
        {
            if([quest.questId isEqualToString:questBasic.questId])
            {
                // get status
                status = quest.status;
            }
        }
    }
    
    // create a new view controller and pass suitable data
    questDemoViewController *contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"questContentViewController"];
    contentViewController.pageIndex = index;
    
    // set text string to be loaded into ui when the view controller is loaded
    contentViewController.questId = questBasic.questId;
    contentViewController.questName = questBasic.questName;
    contentViewController.questImage = [_questImages objectForKey:questBasic.questId];
    contentViewController.questDescription = questBasic.description_;
    contentViewController.questRewards = [_allRewardsLinesForAllQuests objectAtIndex:index];
    contentViewController.questStatus = status;
    
    return contentViewController;
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [_questListAvailable.list.questBasics count];
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
}*/


@end
