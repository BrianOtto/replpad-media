; TODO: Map all the JavaScript functions available for HTMLMediaElement
;       https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement
media-object: make object! [
    id: ""
    
    play: func [] [
        log unspaced ["Playing ID #" id]
        
        ; Allows autoplay and player/play to work with the new browser restrictions
        ; See https://developer.mozilla.org/en-US/docs/Web/Media/Autoplay_guide
        js-do unspaced [{
            var player = document.querySelector('#} id {')
            
            player.play().catch(error => {
                if (error.name === 'NotAllowedError') {
                    player.parentNode.insertAdjacentHTML('beforeend', 
                        '<button onclick="player.play()">Allow Media Playback</button>')
                }
            })
        }]
    ]
    
    pause: func [] [
        log unspaced ["Pausing ID #" id]
        
        js-do unspaced [
            "document.querySelector('#" id "').pause()"
        ]
    ]
    
    log: func [message] [
        js-do unspaced [
            "console.info('rpMedia - " message "')"
        ]
    ]
]