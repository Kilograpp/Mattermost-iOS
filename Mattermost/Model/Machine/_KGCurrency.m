// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGCurrency.m instead.

#import "_KGCurrency.h"

@implementation KGCurrencyID
@end

@implementation _KGCurrency

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Currency" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Currency";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Currency" inManagedObjectContext:moc_];
}

- (KGCurrencyID*)objectID {
	return (KGCurrencyID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"identifierValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identifier"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"rateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"rate"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic base;

@dynamic identifier;

- (int64_t)identifierValue {
	NSNumber *result = [self identifier];
	return [result longLongValue];
}

- (void)setIdentifierValue:(int64_t)value_ {
	[self setIdentifier:@(value_)];
}

- (int64_t)primitiveIdentifierValue {
	NSNumber *result = [self primitiveIdentifier];
	return [result longLongValue];
}

- (void)setPrimitiveIdentifierValue:(int64_t)value_ {
	[self setPrimitiveIdentifier:@(value_)];
}

@dynamic rate;

- (float)rateValue {
	NSNumber *result = [self rate];
	return [result floatValue];
}

- (void)setRateValue:(float)value_ {
	[self setRate:@(value_)];
}

- (float)primitiveRateValue {
	NSNumber *result = [self primitiveRate];
	return [result floatValue];
}

- (void)setPrimitiveRateValue:(float)value_ {
	[self setPrimitiveRate:@(value_)];
}

@dynamic title;

@end

@implementation KGCurrencyAttributes 
+ (NSString *)base {
	return @"base";
}
+ (NSString *)identifier {
	return @"identifier";
}
+ (NSString *)rate {
	return @"rate";
}
+ (NSString *)title {
	return @"title";
}
@end

