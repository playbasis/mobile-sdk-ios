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

@end

@implementation rewardStorePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = self;
    self.delegate = self;
    
    _cachedImages = [NSMutableArray array];
    
    // cache images async
    // start via blocking-call for the first one
    // note: we want to fully show the first page as fast as possible
    [self cacheImageSequectiallyAtIndex:0];
    
    // start from the second one
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i=1; i<[_goodsInfoList count]; i++)
        {
            [self cacheImageSequectiallyAtIndex:i];
        }
    });
    
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
    if(index == [_goodsList.goodsList count])
    {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (rewardItemViewController*)viewControllerAtIndex:(NSUInteger)index
{
    if(([_goodsList.goodsList count] == 0) || (index >= [_goodsList.goodsList count]))
    {
        return nil;
    }
    
    // all of goods-info are loaded in the previous UI
    // get goods-info at the specified index
    PBGoodsInfo_Response *goodsInfo = [_goodsInfoList objectAtIndex:index];
    
    // create a new view controller, and pass goods-id for it to load itself
    rewardItemViewController *contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rewardItemViewController"];
    contentViewController.pageIndex = index;
    contentViewController.goodsInfo = goodsInfo;
    if([_cachedImages count] >= index + 1 && [_cachedImages count] > 0)
        contentViewController.image = [_cachedImages objectAtIndex:index];
    
    return contentViewController;
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [_goodsList.goodsList count];
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

-(void)cacheImageSequectiallyAtIndex:(NSUInteger)index
{
    // get goods-info
    PBGoodsInfo_Response *goodsInfo = [_goodsInfoList objectAtIndex:index];
    
    // get question's image url
    NSString *imageUrl = goodsInfo.goods.image;
    
    // async loading image
    // load and cache image from above url
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    // cache image to be set later when we need to load that particular view controller
    // add one by one, it's sequential, then it's safe
    // this is to show the first image as fast as possible
    [_cachedImages addObject:[UIImage imageWithData:imageData]];
    
    NSLog(@"Complete loading image for %lu", (unsigned long)index);
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
