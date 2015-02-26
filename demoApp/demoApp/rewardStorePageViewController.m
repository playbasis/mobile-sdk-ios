//
//  rewardStorePageViewController.m
//  demoApp
//
//  Created by haxpor on 2/16/15.
//  Copyright (c) 2015 Maethee Chongchitnant. All rights reserved.
//

#import "rewardStorePageViewController.h"
#import "rewardItemViewController.h"
#import "demoAppSettings.h"

@interface rewardStorePageViewController ()

-(void) populatePageView;

@end

@implementation rewardStorePageViewController

@synthesize goodsListInfo = _goodsListInfo;
@synthesize goodsListInfoCachedImages = _goodsListInfoCachedImages;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = self;
    self.delegate = self;
    
    // initially show blank view
    UIViewController *blankView = [self.storyboard instantiateViewControllerWithIdentifier:@"blankViewUIController"];
    NSArray *viewControllers = [NSArray arrayWithObject:blankView];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // create a temp array to hold all cached images only if it's the first time loading this page
    if(_goodsListInfo == nil)
        _goodsListInfoCachedImages = [NSMutableArray array];
    
    // show hud
    [[Playbasis sharedPB] showHUDFromView:self.view withText:@"Loading"];
    
    // we we start fresh, then begin loading process
    if(_goodsListInfo == nil || _goodsListInfoCachedImages == nil || [_goodsListInfoCachedImages count] <= 0)
    {
        // load goods-list in non-blocking way
        [[Playbasis sharedPB] goodsListAsyncWithBlock:^(PBGoodsListInfo_Response *goodsListInfo, NSURL *url, NSError *error) {
            if(!error)
            {
                NSLog(@"%@", goodsListInfo);
                
                // save response
                _goodsListInfo = goodsListInfo;
                
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
                            // add image sequentially
                            [_goodsListInfoCachedImages addObject:image];
                        }];
                    }
                    
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
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            // hide hud
            [[Playbasis sharedPB] hideHUDFromView:self.view];
        });
        
        // all good
        [self populatePageView];
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
    contentViewController.image = [_goodsListInfoCachedImages objectAtIndex:index];
    
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
