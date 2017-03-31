//
//  ViewController.m
//  HelloMyPayPalPayment
//
//  Created by LazyScream on 2017/3/31.
//  Copyright © 2017年 Lazy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, strong)PayPalConfiguration * payPalConfiguration;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _payPalConfiguration = [[PayPalConfiguration alloc]init];
    
    _payPalConfiguration.acceptCreditCards = YES;
    _payPalConfiguration.merchantName = @"iOSetutorials.com";
    _payPalConfiguration.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfiguration.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    _payPalConfiguration.languageOrLocale = [NSLocale preferredLanguages][0];
    _payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    NSLog(@"PayPal SDK %@",[PayPalMobile libraryVersion]);
}

- (IBAction)paypalPaymentProcess:(id)sender {
    
    PayPalItem * item1 = [PayPalItem itemWithName:@"iPhone6" withQuantity:1 withPrice:[NSDecimalNumber decimalNumberWithString:@"745.30"] withCurrency:@"USD" withSku:@"SKU-iPhone6"];
    PayPalItem * item2 = [PayPalItem itemWithName:@"MacPro" withQuantity:1 withPrice:[NSDecimalNumber decimalNumberWithString:@"1000.00"] withCurrency:@"USD" withSku:@"SKU-MacPro"];
    
    NSArray * items = @[item1,item2];
    
    NSDecimalNumber * subtotal = [PayPalItem totalPriceForItems:items];
    NSDecimalNumber * shipping = [[NSDecimalNumber alloc]initWithString:@"5.48"];
    NSDecimalNumber * tax = [[NSDecimalNumber alloc]initWithString:@"1.45"];
    
    PayPalPaymentDetails * paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal withShipping:shipping withTax:tax];
    NSDecimalNumber * total = [[subtotal decimalNumberByAdding:shipping]decimalNumberByAdding:tax];
    
    PayPalPayment * payment = [[PayPalPayment alloc]init];
    payment.amount = total;
    
    payment.currencyCode = @"USD";
    
    payment.shortDescription = @"我的付款";
    payment.items = items;
    payment.paymentDetails = paymentDetails;
    
    if (!payment.processable) {
        
    }
    
    PayPalPaymentViewController * paymentViewController = [[PayPalPaymentViewController alloc]initWithPayment:payment configuration:self.payPalConfiguration delegate:self];
    
    [self presentViewController:paymentViewController animated:YES completion:nil];
}



#pragma mark PayPalSDKDelegate Mathods

-(void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"paypal取消");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"paypal成功");
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
