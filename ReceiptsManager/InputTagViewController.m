//
//  InputTagViewController.m
//  ReceiptsManager
//
//  Created by Narendra Thapa on 2016-02-04.
//  Copyright © 2016 Narendra Thapa. All rights reserved.
//

#import "InputTagViewController.h"
#import "AppDelegate.h"
#import "Tag.h"
#import "TagViewCell.h"

@interface InputTagViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation InputTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tagSavePressed:(UIButton *)sender {
    NSLog(@"Save Button Pressed");
    
    NSManagedObjectContext *context = self.managedObjectContext;

    Tag *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
    
    newManagedObject.tagName = self.enteredTag.text;

    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.delegate newTagDetails:newManagedObject];
    [self.enteredTag resignFirstResponder];
    [self.tableView reloadData];
    [self.enteredTag clearButtonMode];
    //[self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.enteredTag resignFirstResponder];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSError *errR = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *allTags = [self.managedObjectContext executeFetchRequest:fetchRequest error:&errR];
    
    return allTags.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TagViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TagViewCell" forIndexPath:indexPath];
    
    NSError *errR = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *allTags = [self.managedObjectContext executeFetchRequest:fetchRequest error:&errR];
    
    Tag *oneTag = allTags[indexPath.row];
    NSLog(@"%@", oneTag.tagName);
    cell.tagViewCell.text = oneTag.tagName;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSError *errR = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSArray *allTags = [self.managedObjectContext executeFetchRequest:fetchRequest error:&errR];
        
        NSManagedObject *aManagedObject = [allTags objectAtIndex:indexPath.row];
        
        [self.managedObjectContext deleteObject:aManagedObject];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            // Handle the error.
        }
        
        //[tempReceiptArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
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
