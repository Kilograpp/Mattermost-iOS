// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGUser.m instead.

#import "_KGUser.h"

const struct KGUserAttributes KGUserAttributes = {
	.email = @"email",
	.firstName = @"firstName",
	.identifier = @"identifier",
	.lastName = @"lastName",
	.username = @"username",
};

const struct KGUserRelationships KGUserRelationships = {
	.posts = @"posts",
};

@implementation KGUserID
@end

@implementation _KGUser

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
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

@dynamic username;

@dynamic posts;

- (NSMutableSet*)postsSet {
	[self willAccessValueForKey:@"posts"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"posts"];

	[self didAccessValueForKey:@"posts"];
	return result;
}

@end

