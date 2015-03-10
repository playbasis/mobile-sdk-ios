//
//  missionViewController.m
//  demoApp
//
//  Created by Playbasis on 2/6/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import "missionViewController.h"
#import "demoAppSettings.h"

@interface missionViewController ()

@end

@implementation missionViewController

@synthesize mission = _mission;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.missionDescriptionLabel.font = [self.missionDescriptionLabel.font fontWithSize:11];
    self.missionRewardsLabel.font = [self.missionRewardsLabel.font fontWithSize:12];
    self.missionRewardsLabel.numberOfLines = 0;
    
    // set info to containers
    self.missionNameLabel.text = _mission.missionBasic.missionName;
    self.missionDescriptionLabel.text = _mission.missionBasic.description_;
    
    // form rewards string
    NSMutableString *rewardsString = [NSMutableString string];
    NSArray *missionRewards = _mission.missionBasic.rewards.rewards;
    if(missionRewards != nil)
    {
        for(PBReward *reward in missionRewards)
        {
            [rewardsString appendFormat:@"%@ : %@\r", reward.rewardName, reward.rewardValue];
        }
        // cut out /r at the end
        self.missionRewardsLabel.text = [rewardsString substringToIndex:[rewardsString length] - 1];
    }
    else
    {
        // there's nothing to show for mission rewards thus we hide it
        dispatch_async(dispatch_get_main_queue(), ^{
            self.missionRewardsLabel.hidden = YES;
        });
    }
    
    // spining activity indicator
    dispatch_async(dispatch_get_main_queue(), ^{
        self.activityIndicator.hidden = NO;
        // initially disable do-selected-action button
        self.doSelectedActionButton.enabled = NO;
    });
    
    // load image
    [UIImage startLoadingImageInTheBackgroundWithUrl:_mission.missionBasic.image response:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // update image
            self.missionImage.image = image;
            
            // stop spining activity indicator
            self.activityIndicator.hidden = YES;
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_mission != nil && _mission.missionBasic.completions != nil)
        return [_mission.missionBasic.completions.completions count];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sCellIdentifier = @"missionActionCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    
    // get completion
    PBCompletion *completion = [_mission.missionBasic.completions.completions objectAtIndex:[indexPath row]];
    PBPendingArray *pendings = _mission.pendings;
    
    // configure cell
    // set action completion
    UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:1];
    
    // check if this action has been completed by user
    // by checking if it's in pending list then it's not complete yet
    BOOL isActionComplete = YES;
    for(PBPending *pending in pendings.pendings)
    {
        if([completion.completionFilter isEqualToString:pending.incomplete.incompletionFilter])
        {
            isActionComplete = NO;
            break;
        }
    }
    
    if(isActionComplete)
    {
        imageView.image = [UIImage imageNamed:@"complete.png"];
        // tag for completion
        cell.tag = ACTION_COMPLETE;
    }
    else
    {
        imageView.image = [UIImage imageNamed:@"notcomplete.png"];
        // tag for non-completion
        cell.tag = ACTION_NOTCOMPLETE;
    }
    
    // set action title
    UILabel *actionTitle = (UILabel*)[cell.contentView viewWithTag:2];
    actionTitle.text = completion.completionTitle;
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if the cell is already done via action then we don't highlight it
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.tag == ACTION_COMPLETE)
        return false;
    else
        return true;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if selected row that hasn't done the action just yet, then do-selected-button will be enable again
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if(cell.tag == ACTION_COMPLETE)
        self.doSelectedActionButton.enabled = NO;
    else
        self.doSelectedActionButton.enabled = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doSelectedAction:(id)sender {
    
    // get the selected row
    NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
    
    // if selected row already done the action, then return immediately
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:selectedPath];
    if(cell.tag == ACTION_COMPLETE)
        return;
    
    // get completion from the selected row
    PBCompletion *completion = [_mission.missionBasic.completions.completions objectAtIndex:[selectedPath row]];
    
    // get the name of the action to do
    NSString *action = completion.completionData.name;
    
    // get url filter
    // we need this to get the action done correctly
    NSString *url = completion.completionFilter;
    NSString *urlParam = [NSString stringWithFormat:@"url=%@", url];
    
    // show hud
    dispatch_async(dispatch_get_main_queue(), ^{
        [[Playbasis sharedPB] showHUDFromView:self.view withText:[NSString stringWithFormat:@"Doing %@", action]];
    });
    
    // do an action
    [[Playbasis sharedPB] ruleForPlayerAsync:USER action:action withBlock:^(PBRule_Response *response, NSURL *url, NSError *error) {
        if(!error)
        {
            NSLog(@"%@", response);
            NSLog(@"Did '%@'", action);
            NSLog(@"Reload quest information to update mission screen.");
            
            // reload mission
            // we need pending information to reload this mission screen, and update completness indicator of each action
            [[Playbasis sharedPB] questOfPlayer:USER questId:_questId andBlock:^(PBQuestOfPlayer_Response *quest, NSURL *url, NSError *error) {
                if(!error)
                {
                    NSLog(@"Got updated mission info back.");
                    NSLog(@"Ready to refresh mission screen.");
                    
                    // save data for this mission
                    // use pageIndex to specifiy which mission to get information from
                    _mission = [quest.quest.missions.missions objectAtIndex:self.pageIndex];
                    
                    // reload table
                    [self.tableView reloadData];
                    
                    // update UI
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // hide hud
                        [[Playbasis sharedPB] hideHUDFromView:self.view];
                        
                        self.doSelectedActionButton.enabled = NO;
                        
                        // show update status
                        [[Playbasis sharedPB] showFeedbackStatusUpdateWithText:[NSString stringWithFormat:@"You did %@.", action]];
                    });
                }
                else
                {
                    NSLog(@"Error occurs %@", error);
                    
                    // hide hud
                    [[Playbasis sharedPB] hideHUDFromView:self.view];
                }
            }];
        }
        else
        {
            NSLog(@"Error occurs : %@", error);
            
            // hide hud
            [[Playbasis sharedPB] hideHUDFromView:self.view];
        }
    }, urlParam, nil];
}
@end
