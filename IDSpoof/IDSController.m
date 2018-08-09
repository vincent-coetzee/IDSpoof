//
//  IDSController.m
//  IDSpoof
//
//  Created by Vincent Coetzee on 2013/12/07.
//  Copyright (c) 2013 Vincent Coetzee. All rights reserved.
//

#import "IDSController.h"

@implementation IDSController
	{
	IBOutlet __weak NSTextField* dobField;
	IBOutlet __weak NSPopUpButton* genderField;
	IBOutlet __weak NSTextField* indexField;
	IBOutlet __weak NSPopUpButton* citzienshipField;
	IBOutlet __weak NSPopUpButton* dummyField;
	IBOutlet __weak NSTextField* controlDigitField;
	IBOutlet __weak NSTextField* idNumberField;
	__strong NSMutableString* idString;
	}
	
- (void) awakeFromNib
	{			
	idString = [[NSMutableString alloc] initWithString: @"YYMMDDGIDXC8C"];
	idNumberField.stringValue = idString;
	}
	
- (NSMutableString*) padString: (NSString*) string rightWith: (NSString*) padding toLength: (int) length
	{
	NSMutableString* temp;
	
	temp = [[NSMutableString alloc] initWithString: string];
	while ([temp length] < length)
		{
		[temp appendString: padding];
		}
	return(temp);
	}
	
- (void) buildString
	{
	NSString* tempString;
	
	tempString = dobField.stringValue;
	tempString = [self padString: tempString rightWith: @"0" toLength: 6];
	idString = [[NSMutableString alloc] initWithString: tempString];
	[idString appendString: [[genderField selectedItem] title]];
	tempString = indexField.stringValue;
	tempString = [self padString: tempString rightWith: @"0" toLength: 3];
	[idString appendString: tempString];
	[idString appendString: [[citzienshipField selectedItem] title]];
	[idString appendString: [[dummyField selectedItem] title]];
	}
	
- (void)controlTextDidChange:(NSNotification *)aNotification
	{
	[self buildString];
	[self calculateChecksum];
	idNumberField.stringValue = idString;
	}
	
- (IBAction) somethingChanged: (id) sender
	{
	[self buildString];
	[self calculateChecksum];
	idNumberField.stringValue = idString;
	}
	
- (NSInteger) valueOfDigitAtIndex: (int) index
	{
	NSString* string;
	
	string = [idString substringWithRange: NSMakeRange(index-1,1)];
	return([string intValue]);
	}
	
- (NSString*) stringValueOfDigitAtIndex: (int) index
	{
	return( [idString substringWithRange: NSMakeRange(index-1,1)]);
	}
	
- (IBAction) calculateChecksum
	{
	NSInteger totalA;
	NSInteger totalB;
	NSInteger totalC;
	NSMutableString* number;
	
	totalA = [self valueOfDigitAtIndex: 1] + [self valueOfDigitAtIndex: 3] + [self valueOfDigitAtIndex: 5] + [self valueOfDigitAtIndex: 7] + [self valueOfDigitAtIndex: 9] + [self valueOfDigitAtIndex: 11];
	number = [NSMutableString new];
	[number appendString: [self stringValueOfDigitAtIndex: 2]];
	[number appendString: [self stringValueOfDigitAtIndex: 4]];
	[number appendString: [self stringValueOfDigitAtIndex: 6]];
	[number appendString: [self stringValueOfDigitAtIndex: 8]];
	[number appendString: [self stringValueOfDigitAtIndex: 10]];
	[number appendString: [self stringValueOfDigitAtIndex: 12]];
	totalB = [number intValue]*2;
	number = [NSMutableString stringWithFormat: @"%ld",totalB];
	totalB = 0;
	for (int index=0;index<[number length];index++)
		{
		totalB += [[number substringWithRange: NSMakeRange(index,1)] intValue];
		}
	totalC = totalA + totalB;
	totalC = totalC % 10;
	totalC = 10 - totalC;
	totalC = totalC == 10 ? 0 : totalC;
	number = [NSMutableString stringWithFormat: @"%ld",(long)totalC];
	[idString appendString: number];
	controlDigitField.stringValue = number;
	}
	
@end
