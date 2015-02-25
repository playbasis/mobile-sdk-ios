//
//  questPageViewController.m
//  demoApp
//
//  Created by haxpor on 2/6/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "questPageViewController.h"
#import "questDemoViewController.h"
#import "Playbasis.h"
#import "demoAppSettings.h"

@interface questPageViewController ()

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
    
    // initialize all empty arrays
    _cachedQuestImages = [NSMutableDictionary dictionary];
    _allRewardsLinesForAllQuests = [NSMutableArray array];
    
    // show hud (spining activity indicator)
    [[Playbasis sharedPB] showHUDFromView:self.view withText:@"Loading"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // load all quests available to player
        [[Playbasis sharedPB] questListAvailableForPlayer:USER withBlock:^(PBQuestListAvailableForPlayer_Response *list, NSURL *url, NSError *error) {
            if(!error)
            {
                // save the response
                questListAvailable_ = list;
                
                // async load all image from the quest-list
                for(PBQuestBasic *q in questListAvailable_.list.questBasics)
                {
                    // only the first one, we will do blocking-call loading image
                    static BOOL isFirstOne = YES;
                    // cache loading image in the background
                    if(isFirstOne)
                    {
                        // load image in blocking-call
                        [UIImage startLoadingImageWithUrl:q.image response:^(UIImage *image) {
                            [_cachedQuestImages setValue:image forKey:q.questId];
                        }];
                        
                        // not first one anymore
                        isFirstOne = NO;
                    }
                    else
                    {
                        // load image in non-blocking call
                        [UIImage startLoadingImageInTheBackgroundWithUrl:q.image response:^(UIImage *image) {
                            [_cachedQuestImages setValue:image forKey:q.questId];
                        }];
                    }
                    
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
        }];
        
        // load quest that player has joined to get its status
        [[Playbasis sharedPB] questListOfPlayer:USER withBlock:^(PBQuestListOfPlayer_Response *questList, NSURL *url, NSError *error) {
            if(!error)
            {
                // save the result
                questList_ = questList;
                
                NSLog(@"Complete loading all quests information.");
                
                // set the initial first view controller
                questDemoViewController *viewController = [self viewControllerAtIndex:0];
                NSArray *viewControllers = [NSArray arrayWithObject:viewController];
                [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
                
                // set the current page index for later use when we touch the button
                currentPageIndex = 0;
                
                // hide hud
                [[Playbasis sharedPB] hideHUDFromView:self.view];
            }
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if(index == [questListAvailable_.list.questBasics count])
    {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (questDemoViewController*)viewControllerAtIndex:(NSUInteger)index
{
    if(([questListAvailable_.list.questBasics count] == 0) || (index >= [questListAvailable_.list.questBasics count]))
    {
        return nil;
    }
    
    // get quest basic
    PBQuestBasic *questBasic = [questListAvailable_.list.questBasics objectAtIndex:index];
    
    // get quest at the specified index
    NSString *status = nil;
    
    if(questList_.questList.quests != nil )
    {
        for(PBQuest *quest in questList_.questList.quests)
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
    contentViewController.questImage = [_cachedQuestImages objectForKey:questBasic.questId];
    contentViewController.questDescription = questBasic.description_;
    contentViewController.questRewards = [_allRewardsLinesForAllQuests objectAtIndex:index];
    contentViewController.questStatus = status;
    
    return contentViewController;
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [questListAvailable_.list.questBasics count];
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
