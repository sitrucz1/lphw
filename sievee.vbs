'
' Sieve of Eratosthenes
'

option explicit

sub main()
    const MAX = 121
    dim arr, i, j 
    redim arr(MAX)
    for i=3 to MAX step 2
        arr(i) = TRUE
    next
    for i=3 to sqr(MAX) step 2
        if arr(i) then
            for j=i*i to MAX step i+i
                arr(j) = FALSE
            next
        end if
    next
    wscript.stdout.write "1 2 "
    for i=3 to MAX step 2
        if arr(i) then
            wscript.stdout.write i & " "
        end if
    next
    wscript.echo ""
end sub

call main()
