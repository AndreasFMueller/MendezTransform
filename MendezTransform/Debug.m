//
//  Debug.m
//  iPowerRocket
//
//  Created by Andreas Müller on 26.03.09.
//  Copyright 2009 Hochschule Rapperswil. All rights reserved.
//

#import "Debug.h"
#include <stdarg.h>

#if NDEBUG
BOOL	debug = NO;
#else
BOOL	debug = YES;
#endif /* NDEBUG */

#if NDEBUG
#else /* NDEBUG */
void	NSDebugInternal(const char *file, int line, NSString *format, ...) {
	va_list	ap;
	va_start(ap, format);
	long offset = strlen(file) - 30;
	NSString	*f = nil;
	if (offset < 0) { 
		f = [NSString stringWithFormat: @"%s:%03d[%p]: %@", file, line, [NSThread currentThread], format];
	} else {
		f = [NSString stringWithFormat: @"...%s:%03d[%p]: %@", file + offset, line, [NSThread currentThread], format];
	}
	if (debug) {
		NSLogv(f, ap);
	}
	va_end(ap);
}
#endif /* NDEBUG */
