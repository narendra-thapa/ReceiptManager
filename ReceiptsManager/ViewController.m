//
//  ViewController.m
//  ReceiptsManager
//
//  Created by Narendra Thapa on 2016-02-04.
//  Copyright © 2016 Narendra Thapa. All rights reserved.
//

#import "ViewController.h"
#import "InputViewController.h"
#import "DetailViewController.h"
#import "InputTagViewController.h"
#import "AppDelegate.h"
#import "Tag.h"
#import "Receipt.h"
#import "TableViewCell.h"

@interface ViewController () <InputViewControllerDelegate, InputTagViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray *Tags;

@property (nonatomic) NSMutableArray *SecTags;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Tags = [[NSArray alloc] init];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    NSError *errRr = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    self.Tags = [self.managedObjectContext executeFetchRequest:fetchRequest error:&errRr];
    
    NSLog(@"%lu", (unsigned long)self.Tags.count);
    
    //NSArray *SectionReceipts = [[NSMutableArray alloc] init];
    
    NSMutableArray *SecReceipts = [[NSMutableArray alloc] init];
    self.SecTags = [[NSMutableArray alloc] init];
    
    for (Tag *oneTag in self.Tags) {
        NSArray *SectionTag = [[NSMutableArray alloc] init];
        SectionTag = [oneTag.receipts allObjects];
        
        for (Receipt *oneReceipt in SectionTag) {
            [SecReceipts addObject:oneReceipt];
        }
        [self.SecTags addObject:SecReceipts];
    }
    
    for (NSArray *sectionReceiptArray in self.SecTags) {
        for (Receipt *oneReceipt in sectionReceiptArray) {
            NSLog(@"Receipt : %@", oneReceipt.note);
        }
    }
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//    NSError *errR = nil;
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
//    [fetchRequest setEntity:entity];
//    NSArray *allTags = [self.managedObjectContext executeFetchRequest:fetchRequest error:&errR];
//    return allTags.count;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    NSError *errR = nil;
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Receipt" inManagedObjectContext:self.managedObjectContext];
//    [fetchRequest setEntity:entity];
//    NSArray *allReceipts = [self.managedObjectContext executeFetchRequest:fetchRequest error:&errR];
    
    NSArray *secReceiptsArray = [self.SecTags objectAtIndex:section];

    return secReceiptsArray.count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Tag *headerTag = [self.Tags objectAtIndex:section];
    NSString *header = headerTag.tagName;
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainTableViewCell" forIndexPath:indexPath];
    
//    NSError *errR = nil;
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Receipt" inManagedObjectContext:self.managedObjectContext];
//    [fetchRequest setEntity:entity];
//    NSArray *allReceipts = [self.managedObjectContext executeFetchRequest:fetchRequest error:&errR];
    
    Receipt *oneReceipt = [self.SecTags objectAtIndex:indexPath.section][indexPath.row];

//  Receipt *oneReceipt = allReceipts[indexPath.row];
//  NSLog(@"%@", oneReceipt.note);
    
    cell.noteLabel.text = oneReceipt.note;
    
    return cell;

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
if (editingStyle == UITableViewCellEditingStyleDelete) {
    
    
        NSError *errR = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Receipt" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
    
        NSArray *allReceipts = [self.managedObjectContext executeFetchRequest:fetchRequest error:&errR];

    
        NSManagedObject *aManagedObject = allReceipts[indexPath.row];
        //NSManagedObject *aManagedObject = [self.SecTags objectAtIndex:indexPath.section][indexPath.row];

        [self.managedObjectContext deleteObject:aManagedObject];
    
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            // Handle the error.
        }
        
        //[tempReceiptArray removeObjectAtIndex:indexPath.row];
    
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Input View Controller Delegate

-(void)newItemDetails:(Receipt *)newItem {
    NSLog(@"Save new receipt");
    [self.tableView reloadData];
}

#pragma mark - Input View Controller Delegate

-(void)newTagDetails:(Tag *)newItem {
    NSLog(@"Save new tag");
    
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ShowDetail"]) {
        
        DetailViewController *detailViewController = (DetailViewController *)[segue destinationViewController];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
//        NSError *errR = nil;
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Receipt" inManagedObjectContext:self.managedObjectContext];
//        [fetchRequest setEntity:entity];
//        NSArray *allReceipts = [self.managedObjectContext executeFetchRequest:fetchRequest error:&errR];
//        Receipt *receipt = [allReceipts objectAtIndex:indexPath.row];
        
        Receipt *receipt = [self.SecTags objectAtIndex:indexPath.section][indexPath.row];
        
        detailViewController.receiptInstance = receipt;
        detailViewController.managedObjectContext = self.managedObjectContext;
    }
    else if ([[segue identifier] isEqualToString:@"ShowInput"]) {
        
        InputViewController *inputViewController = (InputViewController *)[segue destinationViewController];
        
        inputViewController.managedObjectContext = self.managedObjectContext;
        inputViewController.delegate = self;
        
    }
    else if ([[segue identifier] isEqualToString:@"InputTag"]) {
        
        InputTagViewController *inputTagViewController = (InputTagViewController *)[segue destinationViewController];
        
        inputTagViewController.managedObjectContext = self.managedObjectContext;
        inputTagViewController.delegate = self;
        
    }
}

@end
