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

	return keyPaths;
}

@dynamic email;

@dynamic firstName;

@dynamic identifier;

@dynamic lastName;

@dynamic nickname;

@dynamic username;

@dynamic channels;

@dynamic posts;

- (NSMutableSet<KGPost*>*)postsSet {
	[self willAccessValueForKey:@"posts"];

	NSMutableSet<KGPost*> *result = (NSMutableSet<KGPost*>*)[self mutableSetValueForKey:@"posts"];

	[self didAccessValueForKey:@"posts"];
	return result;
}

@end

@implementation KGUserAttributes 
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
+ (NSString *)nickname {
	return @"nickname";
}
+ (NSString *)username {
	return @"username";
}
@end

@implementation KGUserRelationships 
+ (NSString *)channels {
	return @"channels";
}
+ (NSString *)posts {
	return @"posts";
}
@end

