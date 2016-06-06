// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGCurrency.m instead.

#import "_KGCurrency.h"

const struct KGCurrencyAttributes KGCurrencyAttributes = {
	.base = @"base",
	.identifier = @"identifier",
	.rate = @"rate",
	.title = @"title",
};

@implementation KGCurrencyID
@end

@implementation _KGCurrency

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
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

	if ([key isEqualToString:@"baseValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"base"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"identifierValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identifier"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic base;

- (float)baseValue {
	NSNumber *result = [self base];
	return [result floatValue];
}

- (void)setBaseValue:(float)value_ {
	[self setBase:@(value_)];
}

- (float)primitiveBaseValue {
	NSNumber *result = [self primitiveBase];
	return [result floatValue];
}

- (void)setPrimitiveBaseValue:(float)value_ {
	[self setPrimitiveBase:@(value_)];
}

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

@dynamic title;

@end

