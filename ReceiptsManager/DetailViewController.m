//
//  DetailViewController.m
//  ReceiptsManager
//
//  Created by Narendra Thapa on 2016-02-04.
//  Copyright © 2016 Narendra Thapa. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailTableViewCell.h"
#import "Tag.h"
#import "Receipt.h"

@interface DetailViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    DetailTableViewCell *detailCell = [[DetailTableViewCell alloc] init];
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    //Receipt *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Receipt" inManagedObjectContext:context];
    
//    detailCell.detailSelectionLabel.text = @"Business/Personal";
    
    self.detailAmountLabel.text = [NSString stringWithFormat:@"%.2f", self.receiptInstance.amount];
    self.detailNoteLabel.text = self.receiptInstance.note;
    
    NSDate *currentDate = [[NSDate alloc] initWithTimeIntervalSince1970:self.receiptInstance.timestamp];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.detailDateLabel.text = [dateformatter stringFromDate:currentDate];
    
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
    
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputTableViewCell" forIndexPath:indexPath];
    
    NSError *errR = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
//    NSArray *allTags = [self.managedObjectContext executeFetchRequest:fetchRequest error:&errR];
    
    NSArray *allTags = [[NSArray alloc] init];
    
    for (Tag *tag in self.receiptInstance.tags) {
        
    }
    
    Tag *oneTag = allTags[indexPath.row];
    
    NSLog(@"%@", oneTag.tagName);
    
    cell.detailSelectionLabel.text = oneTag.tagName;
    
    return cell;
    
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
