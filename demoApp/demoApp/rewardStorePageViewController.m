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
    
    // get goods from array
    PBGoods *goods = [_goodsList.goodsList objectAtIndex:index];
    
    // create a new view controller, and pass goods-id for it to load itself
    rewardItemViewController *contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rewardItemViewController"];
    contentViewController.pageIndex = index;
    contentViewController.goods = goods;
    contentViewController.image = [_goodsListCachedImages objectAtIndex:index];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
