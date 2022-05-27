//
//  Constants.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 11.05.22.
//

import Foundation

struct Constants {
    private static let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    static let CACHES_DIRECTORY_URL = cachesDirectory[0]
    
    static let THUMBNAILS_DIRECTORY_URL = Constants.CACHES_DIRECTORY_URL.appendingPathComponent("Thumbnails")
    
    static let YOUTUBE_SEARCH_API_URL = "https://www.googleapis.com/youtube/v3/search"
    
    static let IOS_BUNDLE_IDENTIFIER_HEADER = "servicecontrol.googleapis.com/net.nemetschek.PirateRadio"
    
    static let IOS_BUNDLE_IDENTIFIER_HEADER_FIELD = "x-ios-bundle-identifier"
    
    static let USER_AGENT = "Mozilla/5.0 (iPhone; CPU iPhone OS 15_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1"
    
    static let USER_AGENT_FIELD = "User-Agent"
    
    static let CONTENT_TYPE = "application/json"
    
    static let CONTENT_TYPE_FIELD = "Content-Type"
    
    static let MOCK_RESULT_JSON_STRING = "{\"kind\":\"youtube#searchListResponse\",\"etag\":\"UJKKL3hZOxW8xJM8GW371sC0Jgo\",\"nextPageToken\":\"CAUQAA\",\"regionCode\":\"BG\",\"pageInfo\":{\"totalResults\":1000000,\"resultsPerPage\":5},\"items\":[{\"kind\":\"youtube#searchResult\",\"etag\":\"rjWemoJF8VsT0kM8kZU0aJ9jqQ4\",\"id\":{\"kind\":\"youtube#video\",\"videoId\":\"ligYjFT33uY\"},\"snippet\":{\"publishedAt\":\"2017-06-17T14:00:05Z\",\"channelId\":\"UCFeUyPY6W8qX8w2o6oSiRmw\",\"title\":\"Extreme Skateboarding and Surfing Panther! | 35 Minute Pink Panther and Pals Compilation\",\"description\":\"Watch the Pink Panther get into mischief while skateboarding and surfing! (1) Pink Pool Fool - After the Pink Panther finds the ...\",\"thumbnails\":{\"default\":{\"url\":\"https://i.ytimg.com/vi/ligYjFT33uY/default.jpg\",\"width\":120,\"height\":90},\"medium\":{\"url\":\"https://i.ytimg.com/vi/ligYjFT33uY/mqdefault.jpg\",\"width\":320,\"height\":180},\"high\":{\"url\":\"https://i.ytimg.com/vi/ligYjFT33uY/hqdefault.jpg\",\"width\":480,\"height\":360}},\"channelTitle\":\"Official Pink Panther\",\"liveBroadcastContent\":\"none\",\"publishTime\":\"2017-06-17T14:00:05Z\"}},{\"kind\":\"youtube#searchResult\",\"etag\":\"HWYBB_EwKuj3b-a9DAeWQTd_0i0\",\"id\":{\"kind\":\"youtube#video\",\"videoId\":\"i25i6vyjIpg\"},\"snippet\":{\"publishedAt\":\"2018-12-03T22:54:24Z\",\"channelId\":\"UCRijo3ddMTht_IHyNSNXpNQ\",\"title\":\"World Record Exercise Ball Surfing | OT 6\",\"description\":\"From rolling on exercise balls to a freezing cold mile-long swim, this episode of Overtime has it all! ▻ Click HERE to subscribe to ...\",\"thumbnails\":{\"default\":{\"url\":\"https://i.ytimg.com/vi/i25i6vyjIpg/default.jpg\",\"width\":120,\"height\":90},\"medium\":{\"url\":\"https://i.ytimg.com/vi/i25i6vyjIpg/mqdefault.jpg\",\"width\":320,\"height\":180},\"high\":{\"url\":\"https://i.ytimg.com/vi/i25i6vyjIpg/hqdefault.jpg\",\"width\":480,\"height\":360}},\"channelTitle\":\"Dude Perfect\",\"liveBroadcastContent\":\"none\",\"publishTime\":\"2018-12-03T22:54:24Z\"}},{\"kind\":\"youtube#searchResult\",\"etag\":\"RRp8fmBzxrNHDgeWvjK4A_zI9aU\",\"id\":{\"kind\":\"youtube#video\",\"videoId\":\"0_-OCK752pE\"},\"snippet\":{\"publishedAt\":\"2013-08-06T07:30:10Z\",\"channelId\":\"UCLeuoGy_hUDTBf5Hk0ynrpQ\",\"title\":\"Teen Beach Movie | &#39;Surf Crazy&#39; Sing Along Music Video 🎶 | Disney Channel UK\",\"description\":\"Check out the official sing-a-long for Surf Crazy from Teen Beach Movie! Learn the words and sing along! Available on Disney+.\",\"thumbnails\":{\"default\":{\"url\":\"https://i.ytimg.com/vi/0_-OCK752pE/default.jpg\",\"width\":120,\"height\":90},\"medium\":{\"url\":\"https://i.ytimg.com/vi/0_-OCK752pE/mqdefault.jpg\",\"width\":320,\"height\":180},\"high\":{\"url\":\"https://i.ytimg.com/vi/0_-OCK752pE/hqdefault.jpg\",\"width\":480,\"height\":360}},\"channelTitle\":\"DisneyChannelUK\",\"liveBroadcastContent\":\"none\",\"publishTime\":\"2013-08-06T07:30:10Z\"}},{\"kind\":\"youtube#searchResult\",\"etag\":\"6C8iPnBYIxHVQowzQk_aVSpyFRk\",\"id\":{\"kind\":\"youtube#video\",\"videoId\":\"NNp0_FpguQA\"},\"snippet\":{\"publishedAt\":\"2019-03-12T11:59:37Z\",\"channelId\":\"UCHE0FLZs17sBaMUGt9N1Qow\",\"title\":\"We Love Peppa Pig  Surfing #17\",\"description\":\"We Love Peppa Pig Surfing #17 Welcome to the Official Peppa Pig channel and the home of Peppa on YouTube! We have ...\",\"thumbnails\":{\"default\":{\"url\":\"https://i.ytimg.com/vi/NNp0_FpguQA/default.jpg\",\"width\":120,\"height\":90},\"medium\":{\"url\":\"https://i.ytimg.com/vi/NNp0_FpguQA/mqdefault.jpg\",\"width\":320,\"height\":180},\"high\":{\"url\":\"https://i.ytimg.com/vi/NNp0_FpguQA/hqdefault.jpg\",\"width\":480,\"height\":360}},\"channelTitle\":\"We Love Peppa Pig\",\"liveBroadcastContent\":\"none\",\"publishTime\":\"2019-03-12T11:59:37Z\"}},{\"kind\":\"youtube#searchResult\",\"etag\":\"tuN7ilu8cOYFh8IL2PkKU5cRLqc\",\"id\":{\"kind\":\"youtube#video\",\"videoId\":\"vH5LYVs-edo\"},\"snippet\":{\"publishedAt\":\"2017-05-08T09:00:03Z\",\"channelId\":\"UC_Ucb4QsP0Mvg3qwP6ubpbw\",\"title\":\"Mickey Mouse Clubhouse - Surfing | Official Disney Junior Africa\",\"description\":\"Join Mickey and friends for fun filled activities in the clubhouse! Only on Disney Junior! Welcome to the official Disney Channel ...\",\"thumbnails\":{\"default\":{\"url\":\"https://i.ytimg.com/vi/vH5LYVs-edo/default.jpg\",\"width\":120,\"height\":90},\"medium\":{\"url\":\"https://i.ytimg.com/vi/vH5LYVs-edo/mqdefault.jpg\",\"width\":320,\"height\":180},\"high\":{\"url\":\"https://i.ytimg.com/vi/vH5LYVs-edo/hqdefault.jpg\",\"width\":480,\"height\":360}},\"channelTitle\":\"Disney Channel Africa\",\"liveBroadcastContent\":\"none\",\"publishTime\":\"2017-05-08T09:00:03Z\"}}]}"
    
    
    static let MOCK_RESULT_NEXT_PAGE_JSON_STRING = "{\"kind\":\"youtube#searchListResponse\",\"etag\":\"xg8EUeNk2hNYca95BVUpqj3Tzi8\",\"nextPageToken\":\"CAoQAA\",\"prevPageToken\":\"CAUQAQ\",\"regionCode\":\"BG\",\"pageInfo\":{\"totalResults\":1000000,\"resultsPerPage\":5},\"items\":[{\"kind\":\"youtube#searchResult\",\"etag\":\"tuN7ilu8cOYFh8IL2PkKU5cRLqc\",\"id\":{\"kind\":\"youtube#video\",\"videoId\":\"vH5LYVs-edo\"},\"snippet\":{\"publishedAt\":\"2017-05-08T09:00:03Z\",\"channelId\":\"UC_Ucb4QsP0Mvg3qwP6ubpbw\",\"title\":\"Mickey Mouse Clubhouse - Surfing | Official Disney Junior Africa\",\"description\":\"Join Mickey and friends for fun filled activities in the clubhouse! Only on Disney Junior! Welcome to the official Disney Channel ...\",\"thumbnails\":{\"default\":{\"url\":\"https://i.ytimg.com/vi/vH5LYVs-edo/default.jpg\",\"width\":120,\"height\":90},\"medium\":{\"url\":\"https://i.ytimg.com/vi/vH5LYVs-edo/mqdefault.jpg\",\"width\":320,\"height\":180},\"high\":{\"url\":\"https://i.ytimg.com/vi/vH5LYVs-edo/hqdefault.jpg\",\"width\":480,\"height\":360}},\"channelTitle\":\"Disney Channel Africa\",\"liveBroadcastContent\":\"none\",\"publishTime\":\"2017-05-08T09:00:03Z\"}},{\"kind\":\"youtube#searchResult\",\"etag\":\"kIgIvwoR7Tw5UzRYzaMHAwH3pVA\",\"id\":{\"kind\":\"youtube#video\",\"videoId\":\"2s4slliAtQU\"},\"snippet\":{\"publishedAt\":\"2011-04-05T12:08:28Z\",\"channelId\":\"UCH6ObyYq3YYvUP9VO8vy0qA\",\"title\":\"Beach Boys - Surfin Usa HD\",\"description\":\"Beach Boys - Surfin Usa - teen wolf - m. fox - soundtrack - mix by stathis sach ...\",\"thumbnails\":{\"default\":{\"url\":\"https://i.ytimg.com/vi/2s4slliAtQU/default.jpg\",\"width\":120,\"height\":90},\"medium\":{\"url\":\"https://i.ytimg.com/vi/2s4slliAtQU/mqdefault.jpg\",\"width\":320,\"height\":180},\"high\":{\"url\":\"https://i.ytimg.com/vi/2s4slliAtQU/hqdefault.jpg\",\"width\":480,\"height\":360}},\"channelTitle\":\"ThePANOS77\",\"liveBroadcastContent\":\"none\",\"publishTime\":\"2011-04-05T12:08:28Z\"}},{\"kind\":\"youtube#searchResult\",\"etag\":\"H2G9esbDcy1sCRqoSRMiXndb4dM\",\"id\":{\"kind\":\"youtube#video\",\"videoId\":\"b7C5d_IcZv4\"},\"snippet\":{\"publishedAt\":\"2013-07-20T07:00:13Z\",\"channelId\":\"UCgwv23FVv3lqh567yagXfNg\",\"title\":\"Ross Lynch, Maia Mitchell, Teen Beach Movie Cast - Surf&#39;s Up (from &quot;Teen Beach Movie&quot;)\",\"description\":\"Stream #TeenBeachMovie and #TeenBeach2 on Disney+. Disney+ is the only place to stream your favorites from Disney, Pixar, ...\",\"thumbnails\":{\"default\":{\"url\":\"https://i.ytimg.com/vi/b7C5d_IcZv4/default.jpg\",\"width\":120,\"height\":90},\"medium\":{\"url\":\"https://i.ytimg.com/vi/b7C5d_IcZv4/mqdefault.jpg\",\"width\":320,\"height\":180},\"high\":{\"url\":\"https://i.ytimg.com/vi/b7C5d_IcZv4/hqdefault.jpg\",\"width\":480,\"height\":360}},\"channelTitle\":\"DisneyMusicVEVO\",\"liveBroadcastContent\":\"none\",\"publishTime\":\"2013-07-20T07:00:13Z\"}},{\"kind\":\"youtube#searchResult\",\"etag\":\"gl35m4rpFGH04o7DkDMCAemxtsc\",\"id\":{\"kind\":\"youtube#video\",\"videoId\":\"blYo4WheVgA\"},\"snippet\":{\"publishedAt\":\"2020-01-17T05:00:07Z\",\"channelId\":\"UC3SEvBYhullC-aaEmbEQflg\",\"title\":\"Mac Miller - Surf\",\"description\":\"Circles is available now: https://wr.lnk.to/circles Directed by Anthony Gaddis & Eric Tilford Produced by language.la Video by ...\",\"thumbnails\":{\"default\":{\"url\":\"https://i.ytimg.com/vi/blYo4WheVgA/default.jpg\",\"width\":120,\"height\":90},\"medium\":{\"url\":\"https://i.ytimg.com/vi/blYo4WheVgA/mqdefault.jpg\",\"width\":320,\"height\":180},\"high\":{\"url\":\"https://i.ytimg.com/vi/blYo4WheVgA/hqdefault.jpg\",\"width\":480,\"height\":360}},\"channelTitle\":\"Mac Miller\",\"liveBroadcastContent\":\"none\",\"publishTime\":\"2020-01-17T05:00:07Z\"}},{\"kind\":\"youtube#searchResult\",\"etag\":\"OVLSzPuQ0MoSCXDeMXEZN3G78vA\",\"id\":{\"kind\":\"youtube#video\",\"videoId\":\"29dL2hztP8A\"},\"snippet\":{\"publishedAt\":\"2020-04-11T19:00:00Z\",\"channelId\":\"UCo_q6aOlvPH7M-j_XGWVgXg\",\"title\":\"STORM DRAIN SURFING\",\"description\":\"THIS EPISODE WAS FILMED PREVIOUSLY. GIVEN THE CURRENT AND EVOLVING SITUATION OF COVID-19 PLEASE ...\",\"thumbnails\":{\"default\":{\"url\":\"https://i.ytimg.com/vi/29dL2hztP8A/default.jpg\",\"width\":120,\"height\":90},\"medium\":{\"url\":\"https://i.ytimg.com/vi/29dL2hztP8A/mqdefault.jpg\",\"width\":320,\"height\":180},\"high\":{\"url\":\"https://i.ytimg.com/vi/29dL2hztP8A/hqdefault.jpg\",\"width\":480,\"height\":360}},\"channelTitle\":\"Jamie O'Brien\",\"liveBroadcastContent\":\"none\",\"publishTime\":\"2020-04-11T19:00:00Z\"}}]}"

    static let DOWNLOADER_API_AS_STRING = "https://youtube.michaelbelgium.me/api/converter/convert"
    
    static let YOUTUBE_WATCH_URL_AS_STRING = "https://www.youtube.com/watch"
    
    static let YOUTUBE_TO_MP3_DOWNLOADS_DIRECTORY_URL = Constants.CACHES_DIRECTORY_URL.appendingPathComponent("YouTubeToMp3Downloads")
    
    static let MP3_DOWNLOADER_API_URL = URL(string: "https://api.vevioz.com/api/button/mp3")
    
    static let CONTENT_TO_BLOCK_JSON = """
                                [
                                    { "trigger": {
                                      "url-filter": "dozubatan.com*"
                                    },
                                    "action": {
                                      "type": "block"
                                    }
                                  },
                                    { "trigger": {
                                      "url-filter": "pseepsie.com*"
                                    },
                                    "action": {
                                      "type": "block"
                                    }
                                  },
                                    { "trigger": {
                                      "url-filter": "toglooman.com*"
                                    },
                                    "action": {
                                      "type": "block"
                                    }
                                  },
                                    { "trigger": {
                                      "url-filter": "my.rtmark.net*"
                                    },
                                    "action": {
                                      "type": "block"
                                    }
                                  },
                                    { "trigger": {
                                      "url-filter": "interstitial-07.com*"
                                    },
                                    "action": {
                                      "type": "block"
                                    }
                                  },
                            
                                    { "trigger": {
                                      "url-filter": "w0wtimelands.com*"
                                    },
                                    "action": {
                                      "type": "block"
                                    }
                                  },
                                  { "trigger": {
                                    "url-filter": "googleads.g.doubleclick.net*"
                                  },
                                  "action": {
                                    "type": "block"
                                  }
                                },
                                {
                                  "trigger": {
                                    "url-filter": "pagead.googlesyndication.com*"
                            
                                  },
                                  "action": {
                                    "type": "block"
                                  }
                                },
                                {
                                  "trigger": {
                                    "url-filter": "pagead1.googlesyndication.com*"
                            
                                  },
                                  "action": {
                                    "type": "block"
                                  }
                                },
                                {
                                  "trigger": {
                                    "url-filter": "pagead2.googlesyndication.com*"
                            
                                  },
                                  "action": {
                                    "type": "block"
                                  }
                            }
                                ]
                            """
    
    static let YOUTUBE_VIDEOS_API_URL = "https://youtube.googleapis.com/youtube/v3/videos"

    static let MOCK_RESULT_VIDEO_LIST_RESULT_JSON_STRING = "{\"kind\":\"youtube#videoListResponse\",\"etag\":\"2eqRVooMeKEFKa6J9TWgcjV5_Xc\",\"items\":[{\"kind\":\"youtube#video\",\"etag\":\"1-VYrP9PPUgkuFpJFVX4ULJgGYA\",\"id\":\"ligYjFT33uY\",\"contentDetails\":{\"duration\":\"PT35M26S\",\"dimension\":\"2d\",\"definition\":\"hd\",\"caption\":\"false\",\"licensedContent\":true,\"regionRestriction\":{\"blocked\":[\"AE\",\"BH\",\"EG\",\"IQ\",\"IR\",\"JO\",\"KW\",\"LB\",\"OM\",\"QA\",\"SA\",\"SY\",\"YE\"]},\"contentRating\":{},\"projection\":\"rectangular\"}},{\"kind\":\"youtube#video\",\"etag\":\"cwBGSJIsn_lp1hyNBZln69xwHMo\",\"id\":\"i25i6vyjIpg\",\"contentDetails\":{\"duration\":\"PT19M29S\",\"dimension\":\"2d\",\"definition\":\"hd\",\"caption\":\"true\",\"licensedContent\":true,\"contentRating\":{},\"projection\":\"rectangular\"}},{\"kind\":\"youtube#video\",\"etag\":\"Oz2X0Jsi-epdI0A_D7-Z1ehccFI\",\"id\":\"0_-OCK752pE\",\"contentDetails\":{\"duration\":\"PT3M53S\",\"dimension\":\"2d\",\"definition\":\"hd\",\"caption\":\"false\",\"licensedContent\":true,\"contentRating\":{},\"projection\":\"rectangular\"}},{\"kind\":\"youtube#video\",\"etag\":\"RLw_1QYyJcgB_1adSP-mV5Vs9Pc\",\"id\":\"NNp0_FpguQA\",\"contentDetails\":{\"duration\":\"PT5M12S\",\"dimension\":\"2d\",\"definition\":\"hd\",\"caption\":\"false\",\"licensedContent\":true,\"contentRating\":{},\"projection\":\"rectangular\"}},{\"kind\":\"youtube#video\",\"etag\":\"NJr0meKmz-ZF7ceyQJvlvXA-h0k\",\"id\":\"vH5LYVs-edo\",\"contentDetails\":{\"duration\":\"PT4M16S\",\"dimension\":\"2d\",\"definition\":\"hd\",\"caption\":\"false\",\"licensedContent\":true,\"contentRating\":{},\"projection\":\"rectangular\"}}],\"pageInfo\":{\"totalResults\":5,\"resultsPerPage\":5}}"
    
    static let MUSIC_PLAYER_LIBRARY_PLAYLISTS_ICON_FILENAME = "music_playlist_black_24pt"
    
    static let MUSIC_PLAYER_LIBRARY_ARTISTS_ICON_FILENAME = "music_artists_black_24pt"
    
    static let MUSIC_PLAYER_LIBRARY_SONGS_ICON_FILENAME = "music_songs_black_24pt"
}
