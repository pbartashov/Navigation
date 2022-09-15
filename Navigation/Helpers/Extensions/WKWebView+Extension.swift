//
//  WKWebView+Extension.swift
//  Navigation
//
//  Created by Павел Барташов on 17.07.2022.
//

import WebKit

extension WKWebView {

    func loadVideoFromYouTube(for id: String) {
        loadHTMLString(embedVideoHtml(for: id), baseURL: nil)
    }

    //https://stackoverflow.com/questions/55629902/how-to-set-iframe-height-and-width-same-as-wkwebview-frame
    func embedVideoHtml(for id: String) -> String {
        """
        <!DOCTYPE html>
        <html>
        <style>
        * { margin: 0; padding: 0; }
        html, body { width: 100%; height: 100%; }
        </style>
        <body>
        <!-- 1. The <iframe> (and video player) will replace this <div> tag. -->
        <div id="player"></div>

        <script>
        var tag = document.createElement('script');

        tag.src = "https://www.youtube.com/iframe_api";
        var firstScriptTag = document.getElementsByTagName('script')[0];
        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

        var player;
        function onYouTubeIframeAPIReady() {
        player = new YT.Player('player', {
        playerVars: { 'autoplay': 1, 'controls': 1, 'playsinline': 1 },
        height: '100%',
        width: '100%',
        videoId: '\(id)',
        events: {
        'onReady': onPlayerReady
        }
        });
        }

        function onPlayerReady(event) {
        event.target.playVideo();
        }
        </script>
        </body>
        </html>
        """
    }
}
