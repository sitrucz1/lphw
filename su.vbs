option explicit

sub main()
    printboard
    dim rows(9,9), cols(9,9), boxs(9,9)
    dim boxstart : boxstart = array(0, 3, 6, 27, 30, 33, 54, 57, 60)
    dim peers(81,20)
    dim i,j,k,m,peer
    ' Rows
    for i = 0 to 8
        for j = 0 to 8
            rows(i,j) = i*9+j
            ' wscript.echo rows(i,j)
        next
    next
    ' for j = 0 to 8
    '     wscript.stdout.write rows(1,j)
    ' next
    ' Columns
    for i = 0 to 8
        for j = 0 to 8
            cols(i,j) = i+9*j
            ' wscript.echo cols(i, j)
        next
    next
    ' Boxes
    for k = 0 to 8
        for i = 0 to 2
            for j = 0 to 2
                boxs(k, i*3+j) = boxstart(k)+j+9*i
                wscript.stdout.write right("  " & cstr(boxs(k, i*3+j)), 2) & " "
            next
        next
        wscript.stdout.writeline
    next
    ' Peers - what can see what
    for k = 5 to 10
        peer = 0
        for i = 0 to 8
            for j = 0 to 8
                if rows(i,j) = k then ' build peers
                    for m = 0 to 8
                        if rows(i,m) <> k then
                            peers(k,peer) = rows(i,m)
                            wscript.echo k, peers(k,peer)
                            peer = peer+1
                        end if
                    next
                    exit for
                end if
            next
        next
    next

end sub

sub printboard()
    dim bars : bars = chr(13) & chr(10) & "+----------+----------+----------+"
    dim i, remainder
    for i = 0 to 80
        if i = 0 or i = 27 or i = 54 then
            wscript.stdout.writeline bars
        elseif i mod 9 = 0 then
            wscript.stdout.writeline ""
        end if
        remainder = i mod 3
        if remainder = 0 or remainder = 3 or remainder = 6 then
            wscript.stdout.write "| "
        end if
        wscript.stdout.write right("  " & cstr(i), 2) & " "
        if i mod 9 = 8 then
            wscript.stdout.write "| "
        end if
    next
    wscript.stdout.writeline bars
end sub

call main()
