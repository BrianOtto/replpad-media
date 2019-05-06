do %media.r
do %audio.r
do %video.r

css-do {
    .media-banner {
        background: #E9ECEF;
        border-color: #222222;
        border-left-width: 5px;
        border-left-style: solid;
        margin-top: 10px;
        padding: 10px;
        padding-left: 15px;
        font-family: 'Noto Sans', sans-serif;
    }
    
    .media-banner a {
        color: #222222;
        font-weight: bold;
        text-decoration: none;
        border-bottom: 1px solid #222222;
        padding-bottom: 2px;
        outline: none;
    }
    
    button {
        color: #222222;
        background: #E9ECEF;
        padding: 10px;
        margin-top: 10px;
        cursor: pointer;
        font-family: 'Noto Sans', sans-serif;
    }
}

; TODO: Accept a param that hides the banner (i.e. /nobanner)
print/html rejoin [
    "<div class=^"media-banner^">"
    "Powered by "
    "<a href=^"https://github.com/BrianOtto/replpad-media^" target=^"_blank^">"
    "REPLPAD Media Library"
    "</a>"
    " 0.1.0"
    "</div>"
]