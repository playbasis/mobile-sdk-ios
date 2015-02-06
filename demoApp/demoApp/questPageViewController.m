//
//  questPageViewController.m
//  demoApp
//
//  Created by haxpor on 2/6/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "questPageViewController.h"
#import "questDemoViewController.h"
#import "playbasis.h"
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
    _pageAllQuestIds = [NSMutableArray array];
    _pageAllQuestNames = [NSMutableArray array];
    _pageAllImages = [NSMutableArray array];
    _pageAllQuestDescriptions = [NSMutableArray array];
    _pageAllQuestRewards = [NSMutableArray array];
    _pageQuestJoinedStatuses = [NSMutableArray array];
    
    // load all quests available to player
    [[Playbasis sharedPB] questsAvailable:USER withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"Response quests availalbe = %@", [jsonResponse description]);
            
            // get 'response'
            NSDictionary *response = [jsonResponse objectForKey:@"response"];
            // get 'quests'
            NSArray *quests = [response objectForKey:@"quests"];
            if([quests count] > 0)
            {
                // set the amount needed to add to images array as it needs to do async downloading thus having to know the size prior to the task
                for(int i=0; i < [quests count]; i++)
                {
                    // add dummy object here, we will modify it later
                    [_pageAllImages addObject:[[NSObject alloc] init]];
                }
                
                for(int i=0; i < [quests count]; i++)
                {
                    // get the current quest
                    NSDictionary *quest = quests[i];
                    
                    // cache quest id
                    [_pageAllQuestIds addObject:[quest objectForKey:@"quest_id"]];
                    
                    // cache quest name
                    [_pageAllQuestNames addObject:[quest objectForKey:@"quest_name"]];
                    
                    // load and cache images (async)
                    // get question's image url
                    NSString *imageUrl = [quest objectForKey:@"image"];
                    
                    int toSaveIndex = i;
                    
                    // async loading image
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        // load and cache image from above url
                        NSURL *url = [NSURL URLWithString:imageUrl];
                        NSData *imageData = [NSData dataWithContentsOfURL:url];
                        
                        // replace to 'toSaveIndex' index
                        [_pageAllImages replaceObjectAtIndex:toSaveIndex withObject:[[UIImage alloc] initWithData:imageData]];
                    });
                    
                    // cache quest description
                    [_pageAllQuestDescriptions addObject:[quest objectForKey:@"description"]];
                    
                    // cache quest rewards
                    NSArray *rewards = [quest objectForKey:@"rewards"];
                    if([rewards count] > 0)
                    {
                        NSMutableString *rewardsLines = [NSMutableString string];
                        
                        for(NSDictionary *reward in rewards)
                        {
                            NSInteger rewardValue = [[reward objectForKey:@"reward_value"] integerValue];
                            
                            NSDictionary *rewardData = [reward objectForKey:@"reward_data"];
                            if(rewardData != nil)
                            {
                                NSString *rewardName = [rewardData objectForKey:@"name"];
                                
                                // form the line
                                NSString *line = [NSString stringWithFormat:@"%@: %u", rewardName, rewardValue];
                                
                                // append to the result string
                                if([rewardsLines length] == 0)
                                    rewardsLines = [NSMutableString stringWithFormat:@"%@%@", rewardsLines, line];
                                else
                                    rewardsLines = [NSMutableString stringWithFormat:@"%@\n%@", rewardsLines, line];
                            }
                            else
                            {
                                // form the line (without reward name)
                                NSString *line = [NSString stringWithFormat:@"Unknown type: %u", rewardValue];
                                
                                // append to the result string
                                if([rewardsLines length] == 0)
                                    rewardsLines = [NSMutableString stringWithFormat:@"%@%@", rewardsLines, line];
                                else
                                    rewardsLines = [NSMutableString stringWithFormat:@"%@\n%@", rewardsLines, line];
                            }
                        }
                        
                        // add to array
                        [_pageAllQuestRewards addObject:rewardsLines];
                    }
                }
            }
            else
            {
                NSLog(@"There's no any quests left");
            }
        }
    }];
    
    // add "NotJoined" string to statuses array, we will replace it properly later
    for(int i=0; i<[_pageAllQuestIds count]; i++)
    {
        [_pageQuestJoinedStatuses addObject:@"NotJoined"];
    }
    
    // load quest complete from player
    [[Playbasis sharedPB] questListOfPlayer:USER withBlock:^(NSDictionary *jsonResponse, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"Quest list of player = %@", [jsonResponse description]);
            
            // get 'response'
            NSDictionary *response = [jsonResponse objectForKey:@"response"];
            // get 'quests'
            NSArray *quests = [response objectForKey:@"quests"];
            if([quests count] > 0)
            {
                for(NSDictionary *quest in quests)
                {
                    // get 'quest_id'
                    NSString *questId = [quest objectForKey:@"quest_id"];
                    
                    // get 'status'
                    NSString *status = [quest objectForKey:@"status"];
                    
                    // find an index to replace the content to correct position in quest-statuses
                    NSUInteger index = [_pageAllQuestIds indexOfObject:questId];
                    if(index != NSNotFound)
                    {
                        // cache to array at a proper index
                        [_pageQuestJoinedStatuses replaceObjectAtIndex:index withObject:status];
                    }
                }
            }
            
            NSLog(@"Complete loading all quests information.");
            
            // set the initial first view controller
            questDemoViewController *viewController = [self viewControllerAtIndex:0];
            NSArray *viewControllers = [NSArray arrayWithObject:viewController];
            [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if(index == [_pageAllQuestIds count])
    {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (questDemoViewController*)viewControllerAtIndex:(NSUInteger)index
{
    if(([_pageAllQuestIds count] == 0) || (index >= [_pageAllQuestIds count]))
    {
        return nil;
    }
    
    // create a new view controller and pass suitable data
    questDemoViewController *contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"questContentViewController"];
    contentViewController.pageIndex = index;
    
    // set text string to be loaded into ui when the view controller is loaded
    contentViewController.questName = [_pageAllQuestNames objectAtIndex:index];
    contentViewController.questImage = [_pageAllImages objectAtIndex:index];
    contentViewController.questDescription = [_pageAllQuestDescriptions objectAtIndex:index];
    contentViewController.questRewards = [_pageAllQuestRewards objectAtIndex:index];
    contentViewController.questStatus = [_pageQuestJoinedStatuses objectAtIndex:index];
    
    return contentViewController;
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [_pageAllQuestIds count];
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
