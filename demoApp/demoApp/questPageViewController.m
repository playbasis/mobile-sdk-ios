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
    
    // initialize all empty arrays
    _loadedImagesForAllQuests = [NSMutableDictionary dictionary];
    _allRewardsLinesForAllQuests = [NSMutableArray array];
    
    // load all quests available to player
    [[Playbasis sharedPB] questListAvailableForPlayer:USER withBlock:^(PBQuestListAvailableForPlayer_Response *list, NSURL *url, NSError *error) {
        if(!error)
        {
            // save the response
            questListAvailable_ = list;
            
            // async load all image from the quest-list
            for(PBQuestBasic *q in questListAvailable_.list.questBasics)
            {
                // load and cache images (async)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    // get question's image url
                    NSString *imageUrl = q.image;
                    
                    // async loading image
                    // load and cache image from above url
                    NSURL *url = [NSURL URLWithString:imageUrl];
                    NSData *imageData = [NSData dataWithContentsOfURL:url];
                    
                    [self.loadedImagesForAllQuests setValue:[[UIImage alloc] initWithData:imageData] forKey:q.questId];
                    
                });
                
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
    
    // load quest complete from player
    [[Playbasis sharedPB] questListOfPlayer:USER withBlock:^(PBQuestListOfPlayer_Response *questList, NSURL *url, NSError *error) {
        if(!error)
        {
            // save the result
            questList_ = questList;
            
            NSLog(@"Complete loading all quests information.");
            
            if([questList_.questList.quests count] > 0)
            {
                // set the initial first view controller
                questDemoViewController *viewController = [self viewControllerAtIndex:0];
                NSArray *viewControllers = [NSArray arrayWithObject:viewController];
                [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
                
                // set the current page index for later use when we touch the button
                currentPageIndex = 0;
            }
            else
            {
                // alert that's there no available quests
                UIAlertView *popup = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"There's no available quests" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [popup show];
            }
        }
    }];
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
    
    // get quest at the specified index
    PBQuest *quest = [questList_.questList.quests objectAtIndex:index];
    
    // get quest basic
    PBQuestBasic *questBasic = [questListAvailable_.list.questBasics objectAtIndex:index];
    
    // create a new view controller and pass suitable data
    questDemoViewController *contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"questContentViewController"];
    contentViewController.pageIndex = index;
    
    // set text string to be loaded into ui when the view controller is loaded
    contentViewController.questId = questBasic.questId;
    contentViewController.questName = questBasic.questName;
    contentViewController.questImage = [_loadedImagesForAllQuests objectForKey:questBasic.questId];
    contentViewController.questDescription = questBasic.description_;
    contentViewController.questRewards = [_allRewardsLinesForAllQuests objectAtIndex:index];
    contentViewController.questStatus = quest.status;
    
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
