'
' Bsearch and Interpolation Search routines
'

option explicit

sub main()
    dim arr(999) ' : arr = array(1, 4, 5, 6, 7, 9, 12, 14, 15, 17, 19) ' arr = array(1, 3, 5, 7, 8, 9) ' arr = array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
    dim timerstart, timerend, i
    for i = 0 to 999 step 1
        arr(i) = int(i*1.5)
    next
    wscript.echo join(arr)
    timerstart = timer
    wscript.echo bsearch(arr, 7)
    wscript.echo bsearch(arr, 0)
    wscript.echo bsearch(arr, 17)
    wscript.echo bsearch(arr, 4)
    wscript.echo bsearch(arr, 6)
    timerend = timer
    wscript.echo "timer => ", timerend - timerstart
    timerstart = timer
    wscript.echo intbsearch(arr, 7)
    wscript.echo intbsearch(arr, 0)
    wscript.echo intbsearch(arr, 17)
    wscript.echo intbsearch(arr, 4)
    wscript.echo intbsearch(arr, 6)
    timerend = timer
    wscript.echo "timer => ", timerend - timerstart
end sub

function bsearch(arr, key)
    dim lo, hi, idx
    lo = 0 : hi = ubound(arr)
    idx = lo + (hi - lo) \ 2
    do while lo < hi and key <> arr(idx)
        wscript.echo "idx => ", idx
        if key < arr(idx) then
            hi = idx-1
        else
            lo = idx+1
        end if
        idx = lo + (hi - lo) \ 2
    loop
    if key = arr(idx) then
        bsearch = idx
    else
        bsearch = -1
    end if
end function

function intbsearch(arr, key)
    dim lo, hi, idx
    lo = 0 : hi = ubound(arr)
    do while arr(lo) <> arr(hi) and arr(lo) <= key and key <= arr(hi)
        idx = int(lo + (key - arr(lo)) / (arr(hi) - arr(lo)) * (hi - lo))
        wscript.echo "idx => ", idx
        if key = arr(idx) then
            intbsearch = idx
            exit function
        elseif key < arr(idx) then
            hi = idx-1
        else
            lo = idx+1
        end if
    loop
    if key = arr(lo) then
        intbsearch = lo
    else
        intbsearch = -1
    end if
end function

call main()
