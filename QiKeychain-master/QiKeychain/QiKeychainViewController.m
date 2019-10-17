//
//  QiKeychainLoginViewController.m
//  QiKeychain
//
//  Created by wangyongwang on 2019/1/29.
//  Copyright © 2019年 QiShare. All rights reserved.
//

#import "QiKeychainViewController.h"
#import "QiKeychainItem.h"


@interface QiKeychainViewController ()

@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

@end

@implementation QiKeychainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"钥匙串的基本使用";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupUI];
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

- (void)setupUI{
    
    CGFloat horMargin = 20.0;
    CGFloat verMargin = 10.0;
    CGFloat textFieldW = CGRectGetWidth(self.view.frame) - horMargin * 2;
    CGFloat textFieldH = 40.0;
    
    UITextField *accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(horMargin, verMargin, textFieldW, textFieldH)];
    accountTextField.placeholder = @"请输入用户名";
    _accountTextField = accountTextField;
    _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:accountTextField];
    accountTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    UITextField *passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(horMargin, CGRectGetMaxY(accountTextField.frame) + verMargin, textFieldW, textFieldH)];
    passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    passwordTextField.placeholder = @"请输入密码";
    _passwordTextField = passwordTextField;
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:passwordTextField];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame: CGRectMake(CGRectGetMidX(self.view.frame) - textFieldW * 0.5, CGRectGetMaxY(passwordTextField.frame) + verMargin, textFieldW, textFieldH)];
    saveBtn.backgroundColor = [UIColor blueColor];
    [saveBtn setTitle:@"保存用户名密码" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    UIButton *queryBtn = [[UIButton alloc] initWithFrame: CGRectMake(CGRectGetMidX(self.view.frame) - textFieldW * 0.5, CGRectGetMaxY(saveBtn.frame) + verMargin, textFieldW, textFieldH)];
    queryBtn.backgroundColor = [UIColor blueColor];
    [queryBtn setTitle:@"查询密码" forState:UIControlStateNormal];
    [queryBtn addTarget:self action:@selector(queryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:queryBtn];
    
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame: CGRectMake(CGRectGetMidX(self.view.frame) - textFieldW * 0.5, CGRectGetMaxY(queryBtn.frame) + verMargin, textFieldW, textFieldH)];
    deleteBtn.backgroundColor = [UIColor blueColor];
    [deleteBtn setTitle:@"删除该item" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn];
    
    UIButton *updateBtn = [[UIButton alloc] initWithFrame: CGRectMake(CGRectGetMidX(self.view.frame) - textFieldW * 0.5, CGRectGetMaxY(deleteBtn.frame) + verMargin, textFieldW, textFieldH)];
    updateBtn.backgroundColor = [UIColor blueColor];
    [updateBtn setTitle:@"更新该item" forState:UIControlStateNormal];
    [updateBtn addTarget:self action:@selector(updateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:updateBtn];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
    [self.view addGestureRecognizer:tapGes];
    
}

- (void)tapGes:(UITapGestureRecognizer*)tapGes {
    
    [self.view endEditing:YES];
    
    NSLog(@"%@", NSBundle.mainBundle.infoDictionary);
//    UIImage *image = [UIImage imageWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"a" ofType:@"png"]];
//    NSLog(@"a");
}

- (void)saveButtonClicked:(UIButton *)sender {
    
    if (_accountTextField.text.length > 0 && _passwordTextField.text.length > 0) {
        NSError *keychainError = [QiKeychainItem saveKeychainWithService:QikeychainService account:_accountTextField.text password:_passwordTextField.text];
        if (keychainError.code == errSecSuccess) {
            [self baseAlertWithTitle:@"保存成功"];
        } else {
            [self baseAlertWithTitle:keychainError.localizedDescription];
        }
    } else {
        [self baseAlertWithTitle:@"用户名或者密码不能为空"];
    }
}

- (void)queryButtonClicked:(UIButton *)sender {
    
    if (_accountTextField.text.length > 0) {
        NSError *keychainError = [QiKeychainItem queryKeychainWithService:QikeychainService account:_accountTextField.text];
        if (keychainError.code == errSecSuccess) {
            _passwordTextField.text = [keychainError.userInfo valueForKey:NSLocalizedDescriptionKey];
            [self baseAlertWithTitle:_passwordTextField.text];
        } else {
            [self baseAlertWithTitle:keychainError.localizedDescription];
        }
    } else {
        [self baseAlertWithTitle:@"用户名不能为空"];
    }
}

- (void)deleteButtonClicked:(UIButton *)sender {
    
    if (_accountTextField.text.length > 0) {
        NSError *keychainError = [QiKeychainItem deleteWithService:QikeychainService account:_accountTextField.text];
        if (keychainError.code == errSecSuccess) {
            [self baseAlertWithTitle:@"删除成功"];
        } else {
            [self baseAlertWithTitle:keychainError.localizedDescription];
        }
    } else {
        [self baseAlertWithTitle:@"用户名不能为空"];
    }
}

- (void)updateButtonClicked:(UIButton *)sender {
    
    if (_accountTextField.text.length > 0 && _passwordTextField.text.length > 0) {
        NSError *keychainError = [QiKeychainItem updateKeychainWithService:QikeychainService account:_accountTextField.text password:_passwordTextField.text];
        if (keychainError.code == errSecSuccess) {
            [self baseAlertWithTitle:@"更新成功"];
        } else {
            [self baseAlertWithTitle:keychainError.localizedDescription];
        }
    } else {
        [self baseAlertWithTitle:@"用户名或者密码不能为空"];
    }
}

@end
