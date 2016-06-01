//
//  rewardStorePageViewController.m
//  demoApp
//
//  Created by Playbasis on 2/16/15.
//  Copyright (c) 2015 Playbasis. All rights reserved.
//

#import "rewardStorePageViewController.h"
#import "rewardItemViewController.h"
#import "demoAppSettings.h"
#import "globalCaching.h"

@interface rewardStorePageViewController ()

-(void) populatePageView;

@end

@implementation rewardStorePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = self;
    self.delegate = self;
    
    // initially show blank view
    UIViewController *blankView = [self.storyboard instantiateViewControllerWithIdentifier:@"blankViewUIController"];
    NSArray *viewControllers = [NSArray arrayWithObject:blankView];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // show hud
    [[Playbasis sharedPB] showHUDFromView:self.view withText:@"Loading"];
    
    // if network is reachable then we make requests
    if([Playbasis sharedPB].isNetworkReachable)
    {
        // create empty array to hold images
        _goodsListInfoImages = [NSMutableArray array];
        
        NSLog(@"Begin loading goodsListAsyncWithBlock");
        
        // load goods-list in non-blocking way
        [[Playbasis sharedPB] goodsListAsync:USER tags:@"" withBlock:^(PBGoodsListInfo_Response *goodsListInfo, NSURL *url, NSError *error) {
            if(!error)
            {
                NSLog(@"%@", goodsListInfo);
                
                // save response
                _goodsListInfo = goodsListInfo;
                // update to globalCaching
                [globalCaching sharedInstance].cachedGoodsListInfo = _goodsListInfo;
                
                // there's no available goods to list
                if(goodsListInfo.goodsList == nil ||
                   [goodsListInfo.goodsList count] <= 0)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // hide hud
                        [[Playbasis sharedPB] hideHUDFromView:self.view];
                        
                        // show alert view there's no available goods-list
                        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Goods List" message:@"There's no goods available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [view show];
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // hide hud
                        [[Playbasis sharedPB] hideHUDFromView:self.view];
                    });
                    
                    // cache all images
                    for(PBGoods *goods in goodsListInfo.goodsList)
                    {
                        [UIImage startLoadingImageWithUrl:goods.image response:^(UIImage *image) {
                            if(image != nil)
                            {
                                // add image sequentially
                                [_goodsListInfoImages addObject:image];
                            }
                        }];
                    }
                    // update to globalCaching
                    [globalCaching sharedInstance].cachedGoodsListInfoImages = _goodsListInfoImages;
                    
                    // all goods then reload the pageview
                    [self populatePageView];
                }
            }
            else
            {
                NSLog(@"%@", error);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // hide hud
                    [[Playbasis sharedPB] hideHUDFromView:self.view];
                    
                    // show alert view indicating error
                    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [view show];
                });
            }
        }];
    }
    // if network cannot be reachable, and cache data is ready
    // then we use cached data
    else if(![Playbasis sharedPB].isNetworkReachable &&
            [globalCaching sharedInstance].goodsListDataReadyToUse)
    {
        NSLog(@"Use cached data.");
        
        // set newly loaded data to globalCaching
        _goodsListInfo = [globalCaching sharedInstance].cachedGoodsListInfo;
        _goodsListInfoImages = [globalCaching sharedInstance].cachedGoodsListInfoImages;
        
        // hide hud
        [[Playbasis sharedPB] hideHUDFromView:self.view];
        
        // all good
        [self populatePageView];
    }
    // network is not reachable, and cached data is not ready
    // thus we show alert and go back to mainmenu
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network error!" message:@"Cannot load data" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)populatePageView
{
    // create view controller
    rewardItemViewController *viewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:viewController];
    
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
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
    NSUInteger index = ((rewardItemViewController*) viewController).pageIndex;
    
    if((index == 0) || (index == NSNotFound))
    {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((rewardItemViewController*) viewController).pageIndex;
    
    if(index == NSNotFound)
    {
        return nil;
    }
    
    index++;
    if(index == [_goodsListInfo.goodsList count])
    {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (rewardItemViewController*)viewControllerAtIndex:(NSUInteger)index
{
    if(([_goodsListInfo.goodsList count] == 0) || (index >= [_goodsListInfo.goodsList count]))
    {
        return nil;
    }
    
    // get goods from array
    PBGoods *goods = [_goodsListInfo.goodsList objectAtIndex:index];
    
    // create a new view controller, and pass goods-id for it to load itself
    rewardItemViewController *contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rewardItemViewController"];
    contentViewController.pageIndex = index;
    contentViewController.goods = goods;
    if([_goodsListInfoImages count]>0)
    {
        contentViewController.image = [_goodsListInfoImages objectAtIndex:index];
    }
    
    
    
    return contentViewController;
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [_goodsListInfo.goodsList count];
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
