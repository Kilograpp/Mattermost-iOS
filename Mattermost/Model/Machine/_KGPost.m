// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGPost.m instead.

#import "_KGPost.h"

@implementation KGPostID
@end

@implementation _KGPost

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Post";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Post" inManagedObjectContext:moc_];
}

- (KGPostID*)objectID {
	return (KGPostID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"createdAtWidthValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"createdAtWidth"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"errorValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"error"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"heightValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"height"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"shouldCheckForMissingFilesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"shouldCheckForMissingFiles"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic attributedMessage;

@dynamic backendPendingId;

@dynamic channelId;

@dynamic createdAt;

@dynamic createdAtString;

@dynamic createdAtWidth;

- (float)createdAtWidthValue {
	NSNumber *result = [self createdAtWidth];
	return [result floatValue];
}

- (void)setCreatedAtWidthValue:(float)value_ {
	[self setCreatedAtWidth:@(value_)];
}

- (float)primitiveCreatedAtWidthValue {
	NSNumber *result = [self primitiveCreatedAtWidth];
	return [result floatValue];
}

- (void)setPrimitiveCreatedAtWidthValue:(float)value_ {
	[self setPrimitiveCreatedAtWidth:@(value_)];
}

@dynamic creationDay;

@dynamic deletedAt;

@dynamic error;

- (BOOL)errorValue {
	NSNumber *result = [self error];
	return [result boolValue];
}

- (void)setErrorValue:(BOOL)value_ {
	[self setError:@(value_)];
}

- (BOOL)primitiveErrorValue {
	NSNumber *result = [self primitiveError];
	return [result boolValue];
}

- (void)setPrimitiveErrorValue:(BOOL)value_ {
	[self setPrimitiveError:@(value_)];
}

@dynamic height;

- (int16_t)heightValue {
	NSNumber *result = [self height];
	return [result shortValue];
}

- (void)setHeightValue:(int16_t)value_ {
	[self setHeight:@(value_)];
}

- (int16_t)primitiveHeightValue {
	NSNumber *result = [self primitiveHeight];
	return [result shortValue];
}

- (void)setPrimitiveHeightValue:(int16_t)value_ {
	[self setPrimitiveHeight:@(value_)];
}

@dynamic identifier;

@dynamic message;

@dynamic shouldCheckForMissingFiles;

- (BOOL)shouldCheckForMissingFilesValue {
	NSNumber *result = [self shouldCheckForMissingFiles];
	return [result boolValue];
}

- (void)setShouldCheckForMissingFilesValue:(BOOL)value_ {
	[self setShouldCheckForMissingFiles:@(value_)];
}

- (BOOL)primitiveShouldCheckForMissingFilesValue {
	NSNumber *result = [self primitiveShouldCheckForMissingFiles];
	return [result boolValue];
}

- (void)setPrimitiveShouldCheckForMissingFilesValue:(BOOL)value_ {
	[self setPrimitiveShouldCheckForMissingFiles:@(value_)];
}

@dynamic type;

@dynamic updatedAt;

@dynamic userId;

@dynamic author;

@dynamic channel;

@dynamic files;

- (NSMutableSet<KGFile*>*)filesSet {
	[self willAccessValueForKey:@"files"];

	NSMutableSet<KGFile*> *result = (NSMutableSet<KGFile*>*)[self mutableSetValueForKey:@"files"];

	[self didAccessValueForKey:@"files"];
	return result;
}

@end

@implementation KGPostAttributes 
+ (NSString *)attributedMessage {
	return @"attributedMessage";
}
+ (NSString *)backendPendingId {
	return @"backendPendingId";
}
+ (NSString *)channelId {
	return @"channelId";
}
+ (NSString *)createdAt {
	return @"createdAt";
}
+ (NSString *)createdAtString {
	return @"createdAtString";
}
+ (NSString *)createdAtWidth {
	return @"createdAtWidth";
}
+ (NSString *)creationDay {
	return @"creationDay";
}
+ (NSString *)deletedAt {
	return @"deletedAt";
}
+ (NSString *)error {
	return @"error";
}
+ (NSString *)height {
	return @"height";
}
+ (NSString *)identifier {
	return @"identifier";
}
+ (NSString *)message {
	return @"message";
}
+ (NSString *)shouldCheckForMissingFiles {
	return @"shouldCheckForMissingFiles";
}
+ (NSString *)type {
	return @"type";
}
+ (NSString *)updatedAt {
	return @"updatedAt";
}
+ (NSString *)userId {
	return @"userId";
}
@end

@implementation KGPostRelationships 
+ (NSString *)author {
	return @"author";
}
+ (NSString *)channel {
	return @"channel";
}
+ (NSString *)files {
	return @"files";
}
@end

