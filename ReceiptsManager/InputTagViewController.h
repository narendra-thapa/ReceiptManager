//
//  InputTagViewController.h
//  ReceiptsManager
//
//  Created by Narendra Thapa on 2016-02-04.
//  Copyright © 2016 Narendra Thapa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"

@protocol InputTagViewControllerDelegate <NSObject>

-(void)newTagDetails:(Tag *)newItem;

@end

@interface InputTagViewController : UIViewController

@property (nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UITextField *enteredTag;

@property (weak, nonatomic) id <InputTagViewControllerDelegate> delegate;

@end
