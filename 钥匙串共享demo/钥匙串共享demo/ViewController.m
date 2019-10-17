//
//  ViewController.m
//  钥匙串共享demo
//
//  Created by ZZ on 2019/10/17.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "ViewController.h"
#import "QiKeychainItem.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tfAccount;
@property (weak, nonatomic) IBOutlet UITextField *tfPwd;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)handleSave:(UIBarButtonItem *)sender {
    if (_tfAccount.text.length > 0 && _tfPwd.text.length > 0) {
        NSError *keychainError = [QiKeychainItem saveKeychainWithService:@"" account:_tfAccount.text password:_tfPwd.text];
        if (keychainError.code == errSecSuccess) {
            NSLog(@"保存成功");
            [self baseAlertWithTitle:@"保存成功"];
        } else {
                [self baseAlertWithTitle:keychainError.localizedDescription];
            }
    } else {
        [self baseAlertWithTitle:@"用户名或者密码不能为空"];
    }
}

- (IBAction)handleDelete:(UIBarButtonItem *)sender {
    if (_tfAccount.text.length > 0) {
        NSError *keychainError = [QiKeychainItem deleteWithService:@"" account:_tfAccount.text];
        if (keychainError.code == errSecSuccess) {
                [self baseAlertWithTitle:@"删除成功"];
            } else {
                [self baseAlertWithTitle:keychainError.localizedDescription];
            }
        } else {
            [self baseAlertWithTitle:@"用户名不能为空"];
        }
}

- (IBAction)handleCheck:(UIBarButtonItem *)sender {
    if (_tfAccount.text.length > 0) {
        NSError *keychainError = [QiKeychainItem queryKeychainWithService:@"" account:_tfAccount.text];
        if (keychainError.code == errSecSuccess) {
            _tfPwd.text = [keychainError.userInfo valueForKey:NSLocalizedDescriptionKey];
            [self baseAlertWithTitle:_tfPwd.text];
        } else {
            [self baseAlertWithTitle:keychainError.localizedDescription];
        }
    } else {
        [self baseAlertWithTitle:@"用户名不能为空"];
    }
}

- (void)baseAlertWithTitle:(NSString *)title {
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
    [alter addAction:action];
    [self presentViewController:alter animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alter dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
