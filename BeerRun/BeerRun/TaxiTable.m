//
//  TaxiTable.m
//  BeerRun
//
//  Created by Jonathan Spohn on 8/24/13.
//  Copyright (c) 2013 LeagueOfPantlessGentlemen. All rights reserved.
//

#import "TaxiTable.h"

@interface TaxiTable ()

@end

#define kGOOGLE_API_KEY @"AIzaSyBMPu1-OpI8S47CnVCpaT5E4BCmSLxTDQ0"


@implementation TaxiTable

-(void) queryGooglePlaces: (CLLocationCoordinate2D) currentLocation withGoogleType: (NSString *) googleType andDistance: (NSInteger) radius  {
    
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@",
                     currentLocation.latitude,
                     currentLocation.longitude,
                     [NSString stringWithFormat:@"%i", radius],
                     googleType,
                     kGOOGLE_API_KEY];
    
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
        [_tableView reloadData];

    });
    
}

-(void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    for (id key in json) {
        
        if ([json objectForKey:@"results"] == @"results"){
            NSDictionary *subDictionary = [json objectForKey:key];
            for(id key in subDictionary){
                NSLog(@"Key: %@, Value %@", key, [json objectForKey: key]);
                
            }
        }
        
        
        
//        if ([subDictionary objectForKey:@"type"] == @"title")
//            [titles addObject:[subDictionary objectForKey:@"title"]];
//        // etc.
    }
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    _taxiList = [[NSArray alloc] initWithArray:[json objectForKey:@"results"]];
    
    //Write out the data to the console.
    //NSLog(@"Google Data: %@", _taxiList);
}



- (IBAction)escape:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    _locationManager = [(AppDelegate*)[UIApplication sharedApplication].delegate locationManager];
    
    CLLocationCoordinate2D currentLocation;
    currentLocation.latitude = _locationManager.location.coordinate.latitude;
    currentLocation.longitude= _locationManager.location.coordinate.longitude;
    
    [self queryGooglePlaces:currentLocation withGoogleType:@"car_rental" andDistance:1000000];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [_taxiList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    cell.textLabel.text = [[_taxiList objectAtIndex:indexPath.row] description];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
