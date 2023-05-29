#import <Foundation/Foundation.h>
#import "GLOWRootListController.h"

@implementation GLOWRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *respring = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring:)];
    self.navigationItem.rightBarButtonItem = respring;
}

- (void)respring:(id)sender {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"Respring"
                         message:@"Are you sure you want to respring?"
                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *defaultAction = [UIAlertAction
        actionWithTitle:@"No"
                  style:UIAlertActionStyleCancel
                handler:^(UIAlertAction *action){
                }];

    UIAlertAction *yes = [UIAlertAction
        actionWithTitle:@"Yes"
                  style:UIAlertActionStyleDestructive
                handler:^(UIAlertAction *action) {
                    NSTask *t = [[NSTask alloc] init];
                    FILE *file;
                    if ((file = fopen("/var/jb/usr/bin/sbreload","r"))) {
                     [t setLaunchPath:@"/var/jb/usr/bin/sbreload"];
                    } else {
                     [t setLaunchPath:@"/usr/bin/sbreload"];
                    }
                    [t setArguments:nil];
                    [t launch];
                }];

    [alert addAction:defaultAction];
    [alert addAction:yes];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)openGithubKota {
	[[UIApplication sharedApplication]
	openURL:[NSURL URLWithString:@"https://github.com/R31GNDEV"]
	options:@{}
	completionHandler:nil];
}

-(void)openGithubSnoolie {
	[[UIApplication sharedApplication]
	openURL:[NSURL URLWithString:@"https://github.com/0xilis"]
	options:@{}
	completionHandler:nil];
}

-(void)openGithubMineek {
	[[UIApplication sharedApplication]
	openURL:[NSURL URLWithString:@"https://github.com/mineek"]
	options:@{}
	completionHandler:nil];
}

-(void)buyBadger {
	[[UIApplication sharedApplication]
	openURL:[NSURL URLWithString:@"https://havoc.app/package/badger"]
	options:@{}
	completionHandler:nil];
}

-(void)transDiscord {
	[[UIApplication sharedApplication]
	openURL:[NSURL URLWithString:@"https://discord.gg/queer"]
	options:@{}
	completionHandler:nil];
}
@end
