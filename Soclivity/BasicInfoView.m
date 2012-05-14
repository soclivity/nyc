//
//  BasicInfoView.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BasicInfoView.h"
#import "SoclivityUtilities.h"
#import <QuartzCore/QuartzCore.h>
#define kPicture 0
#define kName 1
#define kEmail 2
#define kPassword 3
#define kConfirm 4
#define kBirthday 5

#define kMale 6
#define kFemale 7

#define kDatePicker 123
@implementation BasicInfoView
@synthesize delegate,enterNameTextField,emailTextField,enterPasswordTextField,confirmPasswordTextField;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Customized fonts
    enterNameTextField.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    enterNameTextField.textColor=[SoclivityUtilities returnTextFontColor:1];
    
    emailTextField.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    emailTextField.textColor=[SoclivityUtilities returnTextFontColor:1];

    enterNameTextField.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    enterNameTextField.textColor=[SoclivityUtilities returnTextFontColor:1];

    enterPasswordTextField.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    enterPasswordTextField.textColor=[SoclivityUtilities returnTextFontColor:1];

    confirmPasswordTextField.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    confirmPasswordTextField.textColor=[SoclivityUtilities returnTextFontColor:1];

    birthdayBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:15];
    
    locationBtnText.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:15];
    
    
    
    birthDayPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,480, 320, 216)];
    birthDayPicker.datePickerMode = UIDatePickerModeDate;
    birthDayPicker.tag=kDatePicker;
    [birthDayPicker setHidden:YES];
    [self addSubview:birthDayPicker];
    [birthDayPicker setEnabled:YES];

    
    
    
}
-(IBAction)BackButtonClicked:(id)sender{
    [delegate BackButtonClicked];
}
-(IBAction)LocationButtonClicked:(id)sender{
    SocLocation=[[LocationCustomManager alloc]init];
    SocLocation.delegate=self;
    SocLocation.theTag=kNoLocation;

}
-(void)LocationAcquired:(NSString*)SoclivityLoc{
    if(SoclivityLoc!=nil){
        [locationBtnText setTitle:SoclivityLoc forState:UIControlStateNormal];
        [locationBtnText setTitleColor:[SoclivityUtilities returnTextFontColor:1] forState:UIControlStateNormal];
    }
}
-(IBAction)genderChanged:(UIButton*)sender{
    
    switch (sender.tag) {
        case kMale:
        {
            
            b_Male=!b_Male;
             [femaleButton setBackgroundImage:[UIImage imageNamed:@"S02_F_notselected.png"] forState:UIControlStateNormal];
            
            if(b_Male){
            [maleButton setBackgroundImage:[UIImage imageNamed:@"S02_male.png"] forState:UIControlStateNormal];
                b_Female=FALSE;
            }else{
                [maleButton setBackgroundImage:[UIImage imageNamed:@"S02_M_notselected.png"] forState:UIControlStateNormal];
                
            }
           

        }
            break;
            
        case kFemale:
        {
            b_Female=!b_Female;
            
            [maleButton setBackgroundImage:[UIImage imageNamed:@"S02_M_notselected.png"] forState:UIControlStateNormal];

            if(b_Female){
            [femaleButton setBackgroundImage:[UIImage imageNamed:@"S02_female.png"] forState:UIControlStateNormal];
                b_Male=FALSE;
            }
            else{
                [femaleButton setBackgroundImage:[UIImage imageNamed:@"S02_F_notselected.png"] forState:UIControlStateNormal];
            }
        }
            break;
        default:
            break;
    }
}
        
-(void)showUploadCaptureSheet{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Upload my profile picture"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Image Gallery", @"Photo Capture",nil];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
    [sheet release];
    
    
}


-(IBAction)birthdayDateSelection:(id)sender{
    
    
    [delegate setPickerSettings];
    birthDayPicker.hidden=NO;
     if (!footerActivated) {
         
    CGRect basketTopFrame = birthDayPicker.frame;
    basketTopFrame.origin.y = -basketTopFrame.size.height;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGRect rect = CGRectMake(0, -156, 320, 480);
    self.frame = rect;
    birthDayPicker.frame=CGRectMake(0, 355, 320, 260);//399
    [UIView commitAnimations];
         footerActivated = YES;
     }
}

-(void)dateSelected{
    
    [self hideBirthdayPicker];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat=@"MMMM d, YYYY";
	NSString*date=[dateFormatter stringFromDate:[birthDayPicker date]];
    [birthdayBtn setTitle:date forState:UIControlStateNormal];
    [birthdayBtn setTitleColor:[SoclivityUtilities returnTextFontColor:1] forState:UIControlStateNormal];
    [dateFormatter release];

}
-(void)hideBirthdayPicker{
    if (footerActivated) {
        CGRect basketTopFrame = birthDayPicker.frame;
        basketTopFrame.origin.y = +basketTopFrame.size.height;
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        CGRect rect = CGRectMake(0, 0, 320, 480);
        self.frame = rect;

        birthDayPicker.frame=CGRectMake(0, 480, 320, 260);
        [UIView commitAnimations];
        footerActivated=NO;
    }
    
}
#pragma mark -
#pragma mark UIActionSheet methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //restore view opacities to normal
    
    switch (buttonIndex) {
        case 0:
        {
            [self PushImageGallery];
        }
            break;
            
        case 1:
        {
            [self PushCamera];
        }
            break;
    }
    
}

#pragma mark -
#pragma  mark CustomCamera Gallery and Capture Methods 

-(void)PushImageGallery{
    UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    
	if([UIImagePickerController isSourceTypeAvailable:sourceType]){
        cameraUpload.galleryImage=TRUE;
		cameraUpload.m_picker.sourceType = sourceType;
        [delegate presentModal:cameraUpload.m_picker];
    }
    
}


-(void)PushCamera{
    UIImagePickerControllerSourceType sourceType= UIImagePickerControllerSourceTypeCamera;
	if([UIImagePickerController isSourceTypeAvailable:sourceType]){
        cameraUpload.galleryImage=FALSE;
		cameraUpload.m_picker.sourceType = sourceType;
        [delegate presentModal:cameraUpload.m_picker];
        
	}
    
}

-(void)imageCapture:(UIImage*)Img{
    [delegate dismissPickerModalController];
    
    // If the image is not a square please auto crop
    if(Img.size.height != Img.size.width)
        Img = [self autoCrop:Img];
    
    // If the image needs to be compressed
    if(Img.size.height > 100 || Img.size.width > 100)
        Img = [self compressImage:Img size:CGSizeMake(100,100)];
    
    [profileBtn setBackgroundImage:Img forState:UIControlStateNormal];
    [[profileBtn layer] setBorderWidth:1.0];
    [[profileBtn layer] setBorderColor:[SoclivityUtilities returnTextFontColor:4].CGColor];
    setYourPic.hidden=YES;


}
// Function to auto-crop the image if user does not
-(UIImage*) autoCrop:(UIImage*)image{
    
    CGSize dimensions = {0,0};
    float x=0.0,y=0.0;
    
    // Check to see if the image layout is landscape or portrait
    if(image.size.width > image.size.height)
    {
        // if landscape
        x = (image.size.width - image.size.height)/2;
        dimensions.width = image.size.height;
        dimensions.height = image.size.height;
        
    }
    else
    {
        // if portrait
        y = (image.size.height - image.size.width)/2;
        dimensions.height = image.size.width;
        dimensions.width = image.size.width;
                
    }
    
    // Create the mask
    CGRect imageRect = CGRectMake(x,y,dimensions.width,dimensions.height);
    
    // Create the image based on the mask created above
    CGImageRef  imageRef = CGImageCreateWithImageInRect([image CGImage], imageRect);
    image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
	return image;
}

// Function to compress a large image
-(UIImage*) compressImage:(UIImage *)image size:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    CGRect imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
    [image drawInRect:imageRect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)dismissPickerModalController{
    
    [delegate dismissPickerModalController];
}


-(IBAction)ProfileBtnClicked:(UIButton*)sender{
    cameraUpload=[[CameraCustom alloc]init];
    cameraUpload.delegate=self;
    [self showUploadCaptureSheet];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
     NSLog(@"touchesBegan");
    
    
    
    [emailTextField resignFirstResponder];
    [confirmPasswordTextField resignFirstResponder];
    [enterNameTextField resignFirstResponder];
    [enterPasswordTextField resignFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.25];
    CGRect rect = CGRectMake(0, 0, 320, 480);
    self.frame = rect;
    [UIView commitAnimations];
    
    if(footerActivated){
        
        [delegate hidePickerView:nil];
        
    }
    
}
#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    //set color for placeholder text
    textField.textColor = [SoclivityUtilities returnTextFontColor:1];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
	
    
    
    NSLog(@"textFieldDidBeginEditing");
    if(footerActivated){
    
        [delegate hidePickerView:nil];
    }
    if((textField==enterPasswordTextField)||(textField==confirmPasswordTextField)){
        
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25];
        CGRect rect = CGRectMake(0, -80, 320, 480);
        self.frame = rect;
        [UIView commitAnimations];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	
    [textField resignFirstResponder];
    
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.25];
    CGRect rect = CGRectMake(0, 0, 320, 480);
    self.frame = rect;
    [UIView commitAnimations];
        
		
        
    
	return NO;
}
@end
