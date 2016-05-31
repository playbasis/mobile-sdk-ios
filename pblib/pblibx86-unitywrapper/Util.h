#define CHECK_NOTNULL(x) x != nil && x != (id)[NSNull null]
#define COPYSTRING(from, to) if(CHECK_NOTNULL(from)) { to = MakeStringCopy([from UTF8String]); }

// Converts C style string to NSString
inline NSString* CreateNSString (const char* string)
{
	if (string)
		return [NSString stringWithUTF8String: string];
	else
		return [NSString stringWithUTF8String: ""];
}

// Helper method to create C string copy
inline char* MakeStringCopy (const char* string)
{
	if (string == NULL)
		return NULL;
	
	char* res = (char*)malloc(strlen(string) + 1);
	strcpy(res, string);
	return res;
}