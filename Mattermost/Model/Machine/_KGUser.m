// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGUser.m instead.

#import "_KGUser.h"

@implementation KGUserID
@end

@implementation _KGUser

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"User";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc_];
}

- (KGUserID*)objectID {
	return (KGUserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"currentUserValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"currentUser"];
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

@dynamic currentUser;

- (BOOL)currentUserValue {
	NSNumber *result = [self currentUser];
	return [result boolValue];
}

- (void)setCurrentUserValue:(BOOL)value_ {
	[self setCurrentUser:@(value_)];
}

- (BOOL)primitiveCurrentUserValue {
	NSNumber *result = [self primitiveCurrentUser];
	return [result boolValue];
}

- (void)setPrimitiveCurrentUserValue:(BOOL)value_ {
	[self setPrimitiveCurrentUser:@(value_)];
}

@dynamic email;

@dynamic firstName;

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

@dynamic lastName;

@dynamic username;

@dynamic posts;

- (NSMutableSet<KGPost*>*)postsSet {
	[self willAccessValueForKey:@"posts"];

	NSMutableSet<KGPost*> *result = (NSMutableSet<KGPost*>*)[self mutableSetValueForKey:@"posts"];

	[self didAccessValueForKey:@"posts"];
	return result;
}

@end

@implementation KGUserAttributes 
+ (NSString *)currentUser {
	return @"currentUser";
}
+ (NSString *)email {
	return @"email";
}
+ (NSString *)firstName {
	return @"firstName";
}
+ (NSString *)identifier {
	return @"identifier";
}
+ (NSString *)lastName {
	return @"lastName";
}
+ (NSString *)username {
	return @"username";
}
@end

@implementation KGUserRelationships 
+ (NSString *)posts {
	return @"posts";
}
@end

