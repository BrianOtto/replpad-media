; TODO: Map all the JavaScript functions available for HTMLMediaElement
;       https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement
media-object: make object! [
    id: ""
    
    play: func [] [
        js-do rejoin [
            "console.info('rpAudio - Playing ID #" id "')"
        ]
        
        ; Allows autoplay and player/play to work with the new browser restrictions
        ; See https://developer.mozilla.org/en-US/docs/Web/Media/Autoplay_guide
        js-do rejoin [
            "var player = document.querySelector('#" id "')"
            
            {
                player.play().catch(error => {
                    if (error.name === 'NotAllowedError') {
                        player.parentNode.insertAdjacentHTML('beforeend', 
                            '<button onclick="player.play()">Allow Media Playback</button>')
                    }
                })
            }
        ]
    ]
    
    pause: func [] [
        js-do rejoin [
            "console.info('rpAudio - Pausing ID #" id "')"
        ]
        
        js-do rejoin [
            "document.querySelector('#" id "').pause()"
        ]
    ]
]