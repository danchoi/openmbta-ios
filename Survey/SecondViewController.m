//
//  SecondViewController.m
//  TwoSurveys
//
//  Created by Meghan Kane on 5/4/11.
//  Copyright 2011 Massachusetts Institute of Technology. All rights reserved.
//

#import "SecondViewController.h"
#import "DetailViewController.h"

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIAlertView *alert_View = [[[UIAlertView alloc] initWithTitle:@"Please take our 5 minute survey ..." message:nil delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Read More",nil] autorelease];
    [alert_View show];
	
	//Initialize the array.
	listOfItems = [[NSMutableArray alloc] init];
    checked = [[NSMutableArray alloc] init];
	
	NSArray *zipcodeArray = [NSArray arrayWithObjects:@"Zipcode:", nil];
	NSDictionary *zipcodeDict = [NSDictionary dictionaryWithObject:zipcodeArray forKey:@"Survey"];
	
	NSArray *ageArray = [NSArray arrayWithObjects:@"16 to 17", @"18 to 29", @"30 to 39", @"40 to 54", @"55 to 64", @"65 and over", nil];
	NSDictionary *ageDict = [NSDictionary dictionaryWithObject:ageArray forKey:@"Survey"];
	
    NSArray *genderArray = [NSArray arrayWithObjects:@"Male", @"Female", nil];
	NSDictionary *genderDict = [NSDictionary dictionaryWithObject:genderArray forKey:@"Survey"];
    
    NSArray *educArray = [NSArray arrayWithObjects:@"Less than high school", @"High school/GED", @"Technical/vocational school", @"Some college", @"4-year college", @"Graduate school", nil];
	NSDictionary *educDict = [NSDictionary dictionaryWithObject:educArray forKey:@"Survey"];
    
    NSArray *raceEthnicityArray = [NSArray arrayWithObjects:@"White", @"African-American or Black", @"Hispanic or Latino", @"American Indian or Alaska Native", @"Asian", nil];
	NSDictionary *raceEthnicityDict = [NSDictionary dictionaryWithObject:raceEthnicityArray forKey:@"Survey"];
    
    NSArray *incomeArray = [NSArray arrayWithObjects:@"Below $15,000", @"$15,000 to less than $35,000", @"$35,000 to less than $50,000", @"$50,000 to less than $75,000", @"$75,000 to less than $100,000", @"$100,000 or more", nil];
	NSDictionary *incomeDict = [NSDictionary dictionaryWithObject:incomeArray forKey:@"Survey"];
    
    NSArray *bustripsArray = [NSArray arrayWithObjects:@"0-1 trip per week", @"2-5 trips per week", @"6 or more trips per week", nil];
	NSDictionary *bustripsDict = [NSDictionary dictionaryWithObject:bustripsArray forKey:@"Survey"];
    
    NSArray *othertripsArray = [NSArray arrayWithObjects:@"Subway", @"Other local bus", @"Express bus", @"LIRR", @"Other", nil];
    NSDictionary *othertripsDict = [NSDictionary dictionaryWithObject:othertripsArray forKey:@"Survey"];
    
    NSArray *waitArray = [NSArray arrayWithObjects:@"5 minutes or less", @"6 to 10 minutes", @"11 to 15 minutes", @"16 to 20 minutes", @"21 to 25 minutes", @"26 or more minutes", nil];
    NSDictionary *waitDict = [NSDictionary dictionaryWithObject:waitArray forKey:@"Survey"];
    
    NSArray *carArray = [NSArray arrayWithObjects:@"Yes", @"No", nil];
    NSDictionary *carDict = [NSDictionary dictionaryWithObject:carArray forKey:@"Survey"];
    
    NSArray *serviceArray = [NSArray arrayWithObjects:@"Very satisfied", @"Somewhat satisfied", @"Somewhat dissatisfied", @"Very dissatisfied", nil];
    NSDictionary *serviceDict = [NSDictionary dictionaryWithObject:serviceArray forKey:@"Survey"];
    
    NSArray *freqArray = [NSArray arrayWithObjects:@"Whenever you ride the B63", @"Only when you do not see the bus coming", @"Only when you have waited longer than usual", @"Infrequently", @"Almost Never", nil];
    NSDictionary *freqDict = [NSDictionary dictionaryWithObject:freqArray forKey:@"Survey"];
    
    NSArray *accessArray = [NSArray arrayWithObjects:@"BusTime website on computer", @"BusTime website on phone", @"Text messaging/SMS", @"Storefront window display", nil];
    NSDictionary *accessDict = [NSDictionary dictionaryWithObject:accessArray forKey:@"Survey"];
    
    NSArray *relyArray = [NSArray arrayWithObjects:@"Yes", @"No", nil];
    NSDictionary *relyDict = [NSDictionary dictionaryWithObject:relyArray forKey:@"Survey"];
    
    NSArray *btServiceArray = [NSArray arrayWithObjects:@"Very satisfied", @"Somewhat satisfied", @"Somewhat dissatisfied", @"Very dissatisfied", nil];
    NSDictionary *btServiceDict = [NSDictionary dictionaryWithObject:btServiceArray forKey:@"Survey"];
    
    [listOfItems addObject:freqDict];
    [listOfItems addObject:accessDict];
    [listOfItems addObject:relyDict];
    [listOfItems addObject:btServiceDict];
    [listOfItems addObject:bustripsDict];
    [listOfItems addObject:waitDict];
    [listOfItems addObject:othertripsDict];
    [listOfItems addObject:carDict];
    [listOfItems addObject:serviceDict];
	[listOfItems addObject:ageDict];
    [listOfItems addObject:genderDict];
    [listOfItems addObject:educDict];
    [listOfItems addObject:raceEthnicityDict];
    [listOfItems addObject:incomeDict];
    [listOfItems addObject:zipcodeDict];
    
    NSArray *arr = [NSArray arrayWithObjects: @"unchecked",@"unchecked",@"unchecked",@"unchecked",@"unchecked",@"unchecked",@"unchecked", @"unchecked",@"unchecked",@"unchecked",@"unchecked",@"unchecked",@"unchecked",@"unchecked", @"unchecked", nil];
    [checked addObjectsFromArray:arr];
	
	//Set the title
	//self.navigationItem.title = @"Survey (14 Questions)";
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
        
    {
        NSLog(@"close");
    }
    else
    {
        DetailViewController *dvController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:[NSBundle mainBundle]];
        //dvController.selectedCountry = selectedCountry;
        [self.navigationController pushViewController:dvController animated:YES];
        [dvController release];
        dvController = nil;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, [self tableView:tableView heightForHeaderInSection:section])];
    sectionHead.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    sectionHead.userInteractionEnabled = YES;
    sectionHead.tag = section;
    
    UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PlainTableViewSectionHeader_5.png"]];
    headerImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [sectionHead addSubview:headerImage];
    [headerImage release];
    
    UILabel *sectionText = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.tableView.frame.size.width - 10, 40)];
    sectionText.text = [self tableView:tableView titleForHeaderInSection:section];
    sectionText.backgroundColor = [UIColor clearColor];
    sectionText.textColor = [UIColor whiteColor];
    sectionText.shadowColor = [UIColor darkGrayColor];
    sectionText.shadowOffset = CGSizeMake(0,1);
    sectionText.font = [UIFont boldSystemFontOfSize:18];
    sectionText.numberOfLines=2;
    
    [sectionHead addSubview:sectionText];
    [sectionText release];
    
    return [sectionHead autorelease];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 50.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	return [listOfItems count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	//Number of rows it should expect should be based on the section
	NSDictionary *dictionary = [listOfItems objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"Survey"];
	return [array count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
    if(section == 0)
        return @"Q1. How often do you use BusTime for B63?";
    else if(section == 1)
        return @"Q2. Have you used BusTime via...? \n(Check all that apply)";
    else if(section == 2)
        //return @"When you see how far away your bus is (i.e., 3 stops away), can you estimate your wait time?";
        return @"Can you estimate your wait time given the # of stops away?";
    else if (section == 3)
        return @"Overall how satisfied are you with MTA BusTime?";
    else if(section == 4)
        return @"In the past 7 days, how many one-way B63 trips have you taken?";
    else if(section == 5)
        return @"What is your usual wait time?";
    else if(section == 6)
        return @"In past 7 days, have you used...? \n(Check all that apply)";
    else if(section == 7)
        return @"Do you own or have access to a car?";
    else if(section == 8)
        return @"How satisfied are you with overall B63 bus service?";
    else if(section == 9)
        return @"What is your age?";
    else if(section == 10)
        return @"What is your gender?";
    else if(section == 11)
        return @"What is your highest level of education completed?";
    else if(section == 12)
        return @"Are you...? \n(Check all that apply)";
    else if(section == 13)
        return @"Total 2010 household income";
    else
        return @"Where do you live?";
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell
	//First get the dictionary object
	NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
	NSArray *array = [dictionary objectForKey:@"Survey"];
	NSString *cellValue = [array objectAtIndex:indexPath.row];
	cell.textLabel.text = cellValue;
    
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];
    
    return cell;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	
    if (indexPath.section == 14){
        return UITableViewCellAccessoryDisclosureIndicator;}
    else{
        return UITableViewCellAccessoryNone;}
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Retrieve the cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
    //    NSInteger catIndex = [taskCategories indexOfObject:self.currentCategory];
    //   if (catIndex == indexPath.row) {
    //       return;
    //   }
    //    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:indexPath.section inSection:0];
    //    
    //    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    //    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
    //        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    ////        self.currentCategory = [taskCategories objectAtIndex:indexPath.row];
    //    }
    //    
    //    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    //    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
    //        oldCell.accessoryType = UITableViewCellAccessoryNone;
    //    } 
    
    //Get the selected country
    //NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
    //NSArray *array = [dictionary objectForKey:@"Survey"];
    // NSString *selectedCountry = [array objectAtIndex:indexPath.row];
    
    // Takes care of placing checkmarks
    if (indexPath.section != 14) {
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            //    NSLog(@"Is of type NSIndexPath: %@", ([[checked objectAtIndex:(indexPath.section)] isKindOfClass:[NSIndexPath class]])? @"Yes" : @"No");
            
            // Checks if there is already a checkmark in section
            if ([[checked objectAtIndex:(indexPath.section)] isKindOfClass:[NSIndexPath class]] && indexPath.section != 1 && indexPath.section != 6 && indexPath.section != 12){
                // Gets the old cell that was checked and unchecks it
                NSIndexPath *oldIndex = [checked objectAtIndex:(indexPath.section)];
                UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndex];
                oldCell.accessoryType = UITableViewCellAccessoryNone;
            }
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [checked replaceObjectAtIndex:(indexPath.section) withObject:indexPath];
        }
        
        // Unchecks if there is already a checkmark (and no other 
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else{
        //Initialize the detail view controller and display it.
        DetailViewController *dvController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:[NSBundle mainBundle]];
        //dvController.selectedCountry = selectedCountry;
        [self.navigationController pushViewController:dvController animated:YES];
        [dvController release];
        dvController = nil;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate {
    [super setEditing:editing animated:animate];
    [self.tableView setEditing:editing animated:animate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [super dealloc];
}

@end
