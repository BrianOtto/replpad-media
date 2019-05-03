audio-init: false

; TODO: Add support for the <audio> tag and import/export 
;       for different formats like MIDI, LRC, Tablature
audio: func [
    notes [block!]
    /lyrics [text!]
    /volume [integer!]
    /delay [integer!]
    /onend [text!]
    /octave [integer!]
    /key [text!]
    /sig [pair!]
    /bpm [integer!]
][
    lyrics: default [_]
    volume: default [100]
    delay: default [0]
    onend: default [""]
    octave: default [4]
    key: default ["C"]
    sig: default [4x4]
    bpm: default [120]
    
    ; Octave 4
    frequency: mutable [
        "A"  440.00
        "A#" 466.16
        "Bb" 466.16
        "B"  493.88
        "C"  523.25
        "C#" 554.37
        "Db" 554.37
        "D"  587.33
        "D#" 622.25
        "Eb" 622.25
        "E"  659.26
        "F"  698.46
        "F#" 739.99
        "Gb" 739.99
        "G"  783.99
        "G#" 830.61
        "Ab" 830.61
        "R"  000.00 ; rest
    ]
    
    if all [octave != 4 octave > 0] [
        while [not tail? frequency] [
            either octave < 4 [
                frequency/2: me / ((4 - octave) * 2) 
            ][
                frequency/2: me * ((octave - 4) * 2) 
            ]
            
            frequency: next next frequency
        ]
        
        frequency: head frequency
    ]
    
    ; major scales
    ; TODO: Look into automating key adjustments by counting
    switch key [
        "A"  [
            change next find frequency "A" select frequency "F#"
            change next find frequency "B" select frequency "G#"
            change next find frequency "C" select frequency "A"
            change next find frequency "D" select frequency "B"
            change next find frequency "E" select frequency "C#"
            change next find frequency "F" select frequency "D"
            change next find frequency "G" select frequency "E"
        ]
        
        "Bb" [
            change next find frequency "A" select frequency "G"
            change next find frequency "B" select frequency "A"
            change next find frequency "C" select frequency "Bb"
            change next find frequency "D" select frequency "C"
            change next find frequency "E" select frequency "D"
            change next find frequency "F" select frequency "Eb"
            change next find frequency "G" select frequency "F"
        ]
        
        "B"  [
            change next find frequency "A" select frequency "G#"
            change next find frequency "B" select frequency "A#"
            change next find frequency "C" select frequency "B"
            change next find frequency "D" select frequency "C#"
            change next find frequency "E" select frequency "D#"
            change next find frequency "F" select frequency "E"
            change next find frequency "G" select frequency "F#"
        ]
        
        "Db" [
            change next find frequency "A" select frequency "Bb"
            change next find frequency "B" select frequency "C"
            change next find frequency "C" select frequency "Db"
            change next find frequency "D" select frequency "Eb"
            change next find frequency "E" select frequency "F"
            change next find frequency "F" select frequency "Gb"
            change next find frequency "G" select frequency "Ab"
        ]
        
        "D"  [
            change next find frequency "A" select frequency "B"
            change next find frequency "B" select frequency "C#"
            change next find frequency "C" select frequency "D"
            change next find frequency "D" select frequency "E"
            change next find frequency "E" select frequency "F#"
            change next find frequency "F" select frequency "G"
            change next find frequency "G" select frequency "A"
        ]
        
        "Eb" [
            change next find frequency "A" select frequency "C"
            change next find frequency "B" select frequency "D"
            change next find frequency "C" select frequency "Eb"
            change next find frequency "D" select frequency "F"
            change next find frequency "E" select frequency "G"
            change next find frequency "F" select frequency "Ab"
            change next find frequency "G" select frequency "Bb"
        ]
        
        "E"  [
            change next find frequency "A" select frequency "C#"
            change next find frequency "B" select frequency "D#"
            change next find frequency "C" select frequency "E"
            change next find frequency "D" select frequency "F#"
            change next find frequency "E" select frequency "G#"
            change next find frequency "F" select frequency "A"
            change next find frequency "G" select frequency "B"
        ]
        
        "F"  [
            change next find frequency "A" select frequency "D"
            change next find frequency "B" select frequency "E"
            change next find frequency "C" select frequency "F"
            change next find frequency "D" select frequency "G"
            change next find frequency "E" select frequency "A"
            change next find frequency "F" select frequency "Bb"
            change next find frequency "G" select frequency "C"
        ]
        
        "F#" [
            change next find frequency "A" select frequency "D#"
            change next find frequency "B" select frequency "E#"
            change next find frequency "C" select frequency "F#"
            change next find frequency "D" select frequency "G#"
            change next find frequency "E" select frequency "A#"
            change next find frequency "F" select frequency "B"
            change next find frequency "G" select frequency "C#"
        ]
        
        "G"  [
            change next find frequency "A" select frequency "E"
            change next find frequency "B" select frequency "F#"
            change next find frequency "C" select frequency "G"
            change next find frequency "D" select frequency "A"
            change next find frequency "E" select frequency "B"
            change next find frequency "F" select frequency "C"
            change next find frequency "G" select frequency "D"
        ]
        
        "Ab" [
            change next find frequency "A" select frequency "F"
            change next find frequency "B" select frequency "G"
            change next find frequency "C" select frequency "Ab"
            change next find frequency "D" select frequency "Bb"
            change next find frequency "E" select frequency "C"
            change next find frequency "F" select frequency "Db"
            change next find frequency "G" select frequency "Eb"
        ]
    ]
    
    if not audio-init [
        audio-init: true
        
        js-do {
            var rpAudio = (function() {
                var ac = null
                var acTime = null
                
                return {
                    init: function(start) {
                        ac = new AudioContext()
                        
                        if (!start) {
                            acTime = parseFloat(ac.currentTime)
                        } else {
                            acTime = parseFloat(start)
                        }
                        
                        acTime = acTime.toFixed(2)
                        
                        console.info('rpAudio - Initialized to start in '
                                     + acTime + ' seconds')
                    },
                    
                    play: function(frequency, duration, volume) {
                        if (ac == null) { return }
                        
                        frequency = frequency.toFixed(2)
                        
                        var duration = parseFloat(duration) / 1000
                        duration = duration.toFixed(2)
                        
                        var gain = ac.createGain()
                        gain.connect(ac.destination)
                        gain.gain.value = volume / 100
                        
                        var oscillator = ac.createOscillator()
                        oscillator.connect(gain)
                        oscillator.type = 'square'
                        
                        // TODO: Add support for other waveform types
                        // A sine wave is more natural sounding, but it requires
                        // a higher gain and has clipping / distortion issues.
                        // We might be able to prevent this by ramping up the 
                        // gain slowly by using linearRampToValueAtTime().
                        // oscillator.type = 'sine'
                        
                        oscillator.frequency.setValueAtTime(frequency, acTime)
                        
                        console.info('rpAudio - Playing ' + frequency + ' Hz at '
                                     + acTime + ' for ' + duration + ' seconds')
                        
                        oscillator.start(acTime)
                        
                        acTime = parseFloat(acTime) + parseFloat(duration)
                        acTime = acTime.toFixed(2)
                        
                        oscillator.stop(acTime)
                    },
                    
                    exit: function(cb) {
                        if (ac == null) { return }
                        
                        if (ac.currentTime >= acTime) {
                            if (typeof cb == 'function') {
                                ac.close().then(cb)
                            } else {
                                ac.close()
                            }
                            
                            console.info('rpAudio - Exit')
                        } else {
                            setTimeout(function() { rpAudio.exit(cb) }, 100)
                        }
                    }
                }
            })()
        }
    ]
    
    js-do rejoin [
        "rpAudio.init(" delay ")"
    ]
    
    js-do rejoin [
        "console.info('rpAudio - Playing in the key of " key 
        " and using octave " octave "')"
    ]
    
    while [not tail? notes] [
        note: to text! notes/1
        duration: notes/2
        
        ; TODO: Get lyrics queued up in a <div id="lyrics">
        ;       and highlight them as the notes play
        either lyrics [
            lyric: notes/3
            notes: next next next notes
        ][
            notes: next next notes
        ]
        
        if pair? duration [
            ; 120 bpm = 2 beats per second = 0.5 seconds per beat
            seconds-per-beat: 1 / (bpm / 60)
            
            ; 1x2 = half note = 0.5
            duration-as-decimal: duration/1 / duration/2
            
            ; 4x4 = quarter note is 1 beat = 0.25
            sig-as-decimal: 1 / sig/2
            
            ; 0.5 / 0.25 = 2 beats
            beats: duration-as-decimal / sig-as-decimal
            
            ; 2 beats * 0.5 seconds = 1 second for a half note
            duration: beats * seconds-per-beat
            
            duration: me * 1000
        ]
        
        js-do rejoin [
            "rpAudio.play(" select frequency note ", " duration ", " volume ")"
        ]
    ]
    
    js-do rejoin [
        "rpAudio.exit(" onend ")"
    ]
]