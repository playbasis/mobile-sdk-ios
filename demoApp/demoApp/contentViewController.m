//
//  contentViewController.m
//  demoApp
//
//  Created by Patsita Kongkaew on 1/12/16.
//  Copyright © 2016 Maethee Chongchitnant. All rights reserved.
//

#import "contentViewController.h"
#import "demoAppSettings.h"
@implementation contentViewController
-(void)viewDidLoad
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(uploadImage:)];
    
    tapGesture.numberOfTapsRequired = 1;
    
    [tapGesture setDelegate:self];
    [self.photo setUserInteractionEnabled:YES];
    [self.photo addGestureRecognizer:tapGesture];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }

}
-(IBAction)getContent:(id)sender
{
    
        [[Playbasis sharedPB]getContent:nil withBlock:^(PBContent_Response *response, NSURL *url, NSError *error) {
            
            [_detailView setText:[NSString stringWithFormat:@"%@",[response parseLevelJsonResponse]]];
        }];
}
-(IBAction)playerAuth:(id)sender
{
    NSMutableDictionary *options = [[NSMutableDictionary alloc]init];
    [options setObject:@"sm1" forKey:@"username"];
    [[Playbasis sharedPB]playerAuthForPlayerId:@"12345678" options:options withBlock:^(PBPlayer_Response *player, NSURL *url, NSError *error) {
        [_detailView setText:[NSString stringWithFormat:@"%@",[player parseLevelJsonResponse]]];
    }];
}
-(IBAction)listPlayer:(id)sender
{
    [[Playbasis sharedPB]playerListFromNode:@"567c06b85e232a194f8b582c" role:@"employee" withBlock:^(PBPlayerListFromNode_Response *response, NSURL *url, NSError *error) {
        
        [_detailView setText:[NSString stringWithFormat:@"%@",[response list]]];
        
    }];
   
   
}
-(void)uploadImage:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}
#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    self.photo.image = chosenImage;
    if (imageData != nil)
        
    {
        NSString * filenames = [NSString stringWithFormat:@"TextLabel"];
        NSLog(@"%@", filenames);
        
        NSString *urlString = @"http://dev9.edisbest.com/upload_image.php";
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"filenames\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[filenames dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\"TestUploadImg.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"Response : %@",returnString);
        
        if([returnString isEqualToString:@"Success ! The file has been uploaded"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image Saved Successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [alert show];
        }
        NSLog(@"Finish");
    }
    
    /*[[Playbasis sharedPB]uploadImageAsync:image withBlock:^(id jsonResponse, NSURL *url, NSError *error) {
        NSLog(@"%@",jsonResponse);
        
    }];*/
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
