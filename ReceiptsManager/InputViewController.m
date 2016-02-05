//
//  InputViewController.m
//  ReceiptsManager
//
//  Created by Narendra Thapa on 2016-02-04.
//  Copyright © 2016 Narendra Thapa. All rights reserved.
//

#import "InputViewController.h"
#import "InputTableViewCell.h"
#import "Tag.h"

@interface InputViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableSet *tagSet;

@end

@implementation InputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tagSet = [[NSMutableSet alloc] init];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    InputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputTableViewCell" forIndexPath:indexPath];
    
    NSError *errR = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *allTags = [self.managedObjectContext executeFetchRequest:fetchRequest error:&errR];
    
    Tag *oneTag = allTags[indexPath.row];
    NSLog(@"%@", oneTag.tagName);
    
    cell.inputSelectionLabel.text = oneTag.tagName;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.noteEntered resignFirstResponder];
    [self.amountEntered resignFirstResponder];
    
    InputTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSError *errR = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *allTags = [self.managedObjectContext executeFetchRequest:fetchRequest error:&errR];
    
    Tag *oneTag = allTags[indexPath.row];
    
    cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryCheckmark ? UITableViewCellAccessoryNone:UITableViewCellAccessoryCheckmark;
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        [self.tagSet addObject:oneTag];
        NSLog(@"Added %@", oneTag.tagName);
    } else {
        [self.tagSet removeObject:oneTag];
        NSLog(@"Removed %@", oneTag.tagName);
    }
}


- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    NSLog(@"Save Button Pressed");

    NSManagedObjectContext *context = self.managedObjectContext;
    
    Receipt *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Receipt" inManagedObjectContext:context];
    
    newManagedObject.amount = [self.amountEntered.text floatValue];
    newManagedObject.note = self.noteEntered.text;
    newManagedObject.timestamp = [[self.dateEntered date] timeIntervalSince1970];
    newManagedObject.tags = self.tagSet;
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.delegate newItemDetails:newManagedObject];
    
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.noteEntered resignFirstResponder];
    [self.amountEntered resignFirstResponder];
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
