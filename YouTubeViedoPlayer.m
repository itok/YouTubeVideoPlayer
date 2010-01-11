//
//  YouTubeViedoPlayer.m
//
//  Created by itok on 10/01/11.
//  Copyright 2010 itok. All rights reserved.
//

#import "YouTubeViedoPlayer.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation YouTubeViedoPlayer

@synthesize videoId;

-(void) dealloc
{
	[videoId release];
	[m_data release];
	
	if (m_conn) {
		[m_conn cancel];
		[m_conn release];
	}
	
	[super dealloc];
}

-(void) playWithVideoId:(NSString*)_videoId
{
	if (m_conn) {
		[m_conn cancel];
		[m_conn release];
		m_conn = nil;
	}
	if (!m_data) {
		m_data = [[NSMutableData alloc] init];
	}
	[m_data setLength:0];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	self.videoId = _videoId;
	// YouTubeのvideo情報取得
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/get_video_info.php?video_id=%@", _videoId]];
	m_conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
	[m_conn start];
}

#pragma mark NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[m_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

	NSString* str = [[NSString alloc] initWithData:m_data encoding:NSUTF8StringEncoding];
	NSArray* queries = [str componentsSeparatedByString:@"&"];
	for (NSString* query in queries) {
		NSArray* comp = [query componentsSeparatedByString:@"="];
		// tokenをさがす
		if ([[comp objectAtIndex:0] isEqualToString:@"token"]) {
			// mp4の取得URL (fmt=18でmp4指定)
			NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/get_video.php?video_id=%@&t=%@&fmt=18", self.videoId, [comp objectAtIndex:1]]];
			if (url) {
				MPMoviePlayerController* player = [[MPMoviePlayerController alloc] initWithContentURL:url];
				if (player) {
					[player play];
				}
			}
		}
	}
	[str release];	
	
	[m_data setLength:0];
	[m_conn release];
	m_conn = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end
