--iTunes で項目名を変更するスクリプト(c)井上圭司2004.6.20
on run
    tell application "iTunes"
        activate
        set selectedTracks to selection
        if selectedTracks is not {} then
            set theList to {"曲名の文字列置換/削除", "曲名へ文字列追加", "アーティスト", "アルバム", "作曲者", "ジャンル"}
            choose from list theList with prompt "何を一括して変更しますか？" OK button name "OK" cancel button name "キャンセル"
            set theChoice to result as text
            if theChoice is "曲名の文字列置換/削除" then
                set findWord to name of item 1 of selectedTracks
                display dialog "検索する文字列を入力してください。" default answer findWord buttons {" キャンセル ", "OK"} default button 2
                set {text returned:findWord, button returned:clickedBtn} to result
                if (findWord is not "") and (clickedBtn is "OK") then
                    display dialog "置換後の文字列を入力してください。検索する文字を削除する場合には文字を入れずに OK を押してください。" default answer findWord buttons {" キャンセル ", "OK"} default button 2
                    set {text returned:exchangeWord, button returned:clickedBtn} to result
                    if clickedBtn is "OK" then
                        set saveDelimiter to AppleScript's text item delimiters
                        repeat with i in selectedTracks
                            set theName to name of i
                            set AppleScript's text item delimiters to findWord
                            set theName to every text item of theName
                            set AppleScript's text item delimiters to exchangeWord
                            set name of i to theName as text
                        end repeat
                        set AppleScript's text item delimiters to saveDelimiter
                    end if
                end if
            else if theChoice is "曲名へ文字列追加" then
                display dialog "追加する文字列を入力してください。" default answer "" buttons {" キャンセル ", "先頭に追加", "末尾に追加"} default button 2
                set {text returned:joinWord, button returned:clickedBtn} to result
                if (joinWord is not "") and (clickedBtn is not " キャンセル ") then
                    if clickedBtn is "先頭に追加" then
                        repeat with i in selectedTracks
                            set theName to name of i
                            set name of i to joinWord & theName
                        end repeat
                    else
                        repeat with i in selectedTracks
                            set theName to name of i
                            set name of i to theName & joinWord
                        end repeat
                    end if
                end if
            else if theChoice is in theList then
                if theChoice is "アーティスト" then
                    set defautAns to artist of item 1 of selectedTracks
                else if theChoice is "アルバム" then
                    set defautAns to album of item 1 of selectedTracks
                else if theChoice is "ジャンル" then
                    set defautAns to genre of item 1 of selectedTracks
                else
                    set defautAns to composer of item 1 of selectedTracks
                end if
                display dialog theChoice & "を入力して下さい" default answer defautAns buttons {" キャンセル ", "OK"} default button 2
                set {text returned:inputName, button returned:clickedBtn} to result
                if clickedBtn is "OK" then
                    if theChoice is "アーティスト" then
                        repeat with i in selectedTracks
                            set artist of i to inputName
                        end repeat
                    else if theChoice is "アルバム" then
                        repeat with i in selectedTracks
                            set album of i to inputName
                        end repeat
                    else if theChoice is "ジャンル" then
                        repeat with i in selectedTracks
                            set genre of i to inputName
                        end repeat
                    else
                        repeat with i in selectedTracks
                            set composer of i to inputName
                        end repeat
                    end if
                end if
            end if
        else
            activate
            beep 1
            display dialog "変更したい曲を選択してからこのスクリプトを実行してください。" buttons {"OK"} default button 1 with icon stop
        end if
    end tell
    
end run

