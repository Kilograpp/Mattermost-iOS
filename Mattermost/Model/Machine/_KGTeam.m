// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGTeam.m instead.

#import "_KGTeam.h"

const struct KGTeamAttributes KGTeamAttributes = {
	.displayName = @"displayName",
	.name = @"name",
};

@implementation KGTeamID
@end

@implementation _KGTeam

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Team";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Team" inManagedObjectContext:moc_];
}

- (KGTeamID*)objectID {
	return (KGTeamID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic displayName;

@dynamic name;

@end

