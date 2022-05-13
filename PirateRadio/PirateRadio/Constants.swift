//
//  Constants.swift
//  PirateRadio
//
//  Created by Bogdan Kalchev on 11.05.22.
//

import Foundation

struct Constants {
    private static let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    static let cachesDirectoryURL = cachesDirectory[0]
    
    static let thumbnailsDirectoryURL = Constants.cachesDirectoryURL.appendingPathComponent("Thumbnails")
    
    static let youtubeSearchAPIAsString = "https://www.googleapis.com/youtube/v3/search"
    
    static let IOS_BUNDLE_IDENTIFIER_HEADER = "servicecontrol.googleapis.com/net.nemetschek.PirateRadio"
    
    static let IOS_BUNDLE_IDENTIFIER_HEADER_FIELD = "x-ios-bundle-identifier"
    
    static let USER_AGENT = "Mozilla/5.0 (iPhone; CPU iPhone OS 15_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1"
    
    static let USER_AGENT_FIELD = "User-Agent"
    
    static let CONTENT_TYPE = "application/json"
    
    static let CONTENT_TYPE_FIELD = "Content-Type"
    
    static let mockResultJSONString = "{\"kind\":\"youtube#searchListResponse\",\"etag\":\"UJKKL3hZOxW8xJM8GW371sC0Jgo\",\"nextPageToken\":\"CAUQAA\",\"regionCode\":\"BG\",\"pageInfo\":{\"totalResults\":1000000,\"resultsPerPage\":5},\"items\":[{\"kind\":\"youtube#searchResult\",\"etag\":\"rjWemoJF8VsT0kM8kZU0aJ9jqQ4\",\"id\":{\"kind\":\"youtube#video\",\"videoId\":\"ligYjFT33uY\"},\"snippet\":{\"publishedAt\":\"2017-06-17T14:00:05Z\",\"channelId\":\"UCFeUyPY6W8qX8w2o6oSiRmw\",\"title\":\"Extreme Skateboarding and Surfing Panther! | 35 Minute Pink Panther and Pals Compilation\",\"description\":\"Watch the Pink Panther get into mischief while skateboarding and surfing! (1) Pink Pool Fool - After the Pink Panther finds the ...\",\"thumbnails\":{\"default\":{\"url\":\"https://i.ytimg.com/vi/ligYjFT33uY/default.jpg\",\"width\":120,\"height\":90},\"medium\":{\"url\":\"https://i.ytimg.com/vi/ligYjFT33uY/mqdefault.jpg\",\"width\":320,\"height\":180},\"high\":{\"url\":\"https://i.ytimg.com/vi/ligYjFT33uY/hqdefault.jpg\",\"width\":480,\"height\":360}},\"channelTitle\":\"Official Pink Panther\",\"liveBroadcastContent\":\"none\",\"publishTime\":\"2017-06-17T14:00:05Z\"}},{\"kind\":\"youtube#searchResult\",\"etag\":\"HWYBB_EwKuj3b-a9DAeWQTd_0i0\",\"id\":{\"kind\":\"youtube#video\",\"videoId\":\"i25i6vyjIpg\"},\"snippet\":{\"publishedAt\":\"2018-12-03T22:54:24Z\",\"channelId\":\"UCRijo3ddMTht_IHyNSNXpNQ\",\"title\":\"World Record Exercise Ball Surfing | OT 6\",\"description\":\"From rolling on exercise balls to a freezing cold mile-long swim, this episode of Overtime has it all! ▻ Click HERE to subscribe to ...\",\"thumbnails\":{\"default\":{\"url\":\"https://i.ytimg.com/vi/i25i6vyjIpg/default.jpg\",\"width\":120,\"height\":90},\"medium\":{\"url\":\"https://i.ytimg.com/vi/i25i6vyjIpg/mqdefault.jpg\",\"width\":320,\"height\":180},\"high\":{\"url\":\"https://i.ytimg.com/vi/i25i6vyjIpg/hqdefault.jpg\",\"width\":480,\"height\":360}},\"channelTitle\":\"Dude Perfect\",\"liveBroadcastContent\":\"none\",\"publishTime\":\"2018-12-03T22:54:24Z\"}},{\"kind\":\"youtube#searchResult\",\"etag\":\"RRp8fmBzxrNHDgeWvjK4A_zI9aU\",\"id\":{\"kind\":\"youtube#video\",\"videoId\":\"0_-OCK752pE\"},\"snippet\":{\"publishedAt\":\"2013-08-06T07:30:10Z\",\"channelId\":\"UCLeuoGy_hUDTBf5Hk0ynrpQ\",\"title\":\"Teen Beach Movie | &#39;Surf Crazy&#39; Sing Along Music Video 🎶 | Disney Channel UK\",\"description\":\"Check out the official sing-a-long for Surf Crazy from Teen Beach Movie! Learn the words and sing along! Available on Disney+.\",\"thumbnails\":{\"default\":{\"url\":\"https://i.ytimg.com/vi/0_-OCK752pE/default.jpg\",\"width\":120,\"height\":90},\"medium\":{\"url\":\"https://i.ytimg.com/vi/0_-OCK752pE/mqdefault.jpg\",\"width\":320,\"height\":180},\"high\":{\"url\":\"https://i.ytimg.com/vi/0_-OCK752pE/hqdefault.jpg\",\"width\":480,\"height\":360}},\"channelTitle\":\"DisneyChannelUK\",\"liveBroadcastContent\":\"none\",\"publishTime\":\"2013-08-06T07:30:10Z\"}},{\"kind\":\"youtube#searchResult\",\"etag\":\"6C8iPnBYIxHVQowzQk_aVSpyFRk\",\"id\":{\"kind\":\"youtube#video\",\"videoId\":\"NNp0_FpguQA\"},\"snippet\":{\"publishedAt\":\"2019-03-12T11:59:37Z\",\"channelId\":\"UCHE0FLZs17sBaMUGt9N1Qow\",\"title\":\"We Love Peppa Pig  Surfing #17\",\"description\":\"We Love Peppa Pig Surfing #17 Welcome to the Official Peppa Pig channel and the home of Peppa on YouTube! We have ...\",\"thumbnails\":{\"default\":{\"url\":\"https://i.ytimg.com/vi/NNp0_FpguQA/default.jpg\",\"width\":120,\"height\":90},\"medium\":{\"url\":\"https://i.ytimg.com/vi/NNp0_FpguQA/mqdefault.jpg\",\"width\":320,\"height\":180},\"high\":{\"url\":\"https://i.ytimg.com/vi/NNp0_FpguQA/hqdefault.jpg\",\"width\":480,\"height\":360}},\"channelTitle\":\"We Love Peppa Pig\",\"liveBroadcastContent\":\"none\",\"publishTime\":\"2019-03-12T11:59:37Z\"}},{\"kind\":\"youtube#searchResult\",\"etag\":\"tuN7ilu8cOYFh8IL2PkKU5cRLqc\",\"id\":{\"kind\":\"youtube#video\",\"videoId\":\"vH5LYVs-edo\"},\"snippet\":{\"publishedAt\":\"2017-05-08T09:00:03Z\",\"channelId\":\"UC_Ucb4QsP0Mvg3qwP6ubpbw\",\"title\":\"Mickey Mouse Clubhouse - Surfing | Official Disney Junior Africa\",\"description\":\"Join Mickey and friends for fun filled activities in the clubhouse! Only on Disney Junior! Welcome to the official Disney Channel ...\",\"thumbnails\":{\"default\":{\"url\":\"https://i.ytimg.com/vi/vH5LYVs-edo/default.jpg\",\"width\":120,\"height\":90},\"medium\":{\"url\":\"https://i.ytimg.com/vi/vH5LYVs-edo/mqdefault.jpg\",\"width\":320,\"height\":180},\"high\":{\"url\":\"https://i.ytimg.com/vi/vH5LYVs-edo/hqdefault.jpg\",\"width\":480,\"height\":360}},\"channelTitle\":\"Disney Channel Africa\",\"liveBroadcastContent\":\"none\",\"publishTime\":\"2017-05-08T09:00:03Z\"}}]}"
}
