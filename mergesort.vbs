'
' Mergesort - An algorithm to sort numbers by merging.
'

option explicit

const CNT = 50000

sub main()
    dim arr, temp : arr = array(10,9,8,7,6,5,4,3,2,1)
    ' dim arr, temp : arr = array(1,2,3,4,5,6,7,8,9,10)
    ' dim arr, temp : arr = makerandomarray(1, 50)
    redim temp(ubound(arr))
    dim tstart, tend
    if ubound(arr) < 50 then
        wscript.echo join(arr)
    end if
    tstart = timer
    ' mergesorti arr, temp
    mergesort arr, temp, 0, ubound(arr)
    tend = timer
    if ubound(arr) < 50 then
        wscript.echo join(arr)
    end if
    wscript.echo tend-tstart
    wscript.echo "" & issorted(arr)
end sub

function makerandomarray(byval lo, byval hi)
    dim i, arr : redim arr(hi-lo)
    randomize
    for i = 0 to hi-lo
        arr(i) = int((hi-lo+1) * rnd + lo)
    next
    makerandomarray = arr
end function

function min(byval a, byval b)
    if a < b then
        min = a
    else
        min = b
    end if
end function

sub mergesorti(byref arr(), byref temp())
    dim wid, n : wid = 1 : n = ubound(arr)
    do until wid > n
        ' wscript.echo wid
        dim lo : lo = 0
        do until lo > n-wid
            dim mi, hi : mi = lo+wid-1 : hi = mi+wid
            ' wscript.echo lo, mi, min(hi, n)
            if arr(mi) > arr(mi+1) then     ' dont merge if already sorted
                merge arr, temp, lo, mi, min(hi, n)
            end if
            lo = hi+1
        loop ' wscript.echo join(arr)
        wid = wid+wid
    loop
end sub

sub mergesort(byref arr(), byref temp(), byval lo, byval hi)
    if lo < hi then
        if hi-lo < 9 then
            insertsort arr, lo, hi
        else
            dim mi : mi = lo + (hi - lo) \ 2
            mergesort arr, temp, lo, mi
            mergesort arr, temp, mi+1, hi
            ' wscript.echo "lo, mi, hi: ", lo, mi, hi
            if arr(mi) > arr(mi+1) then ' no need to merge if already sorted
                merge arr, temp, lo, mi, hi
            end if
        end if
        ' wscript.echo join(arr)
    end if
end sub

sub merge(byref arr(), byref temp(), byval lo, byval mi, byval hi)
    dim k
    ' make a copy of the array so we can replace it
    for k = lo to hi
        temp(k) = arr(k)
    next
    ' merge temp i..mi, j..hi to arr
    dim i, j : k = lo : i = lo : j = mi+1
    do until i > mi or j > hi
        if temp(i) <= temp(j) then
            arr(k) = temp(i)
            i = i+1
        else
            arr(k) = temp(j)
            j = j+1
        end if
        k = k+1
    loop
    ' Copy the rest of the first array
    for i = i to mi
        arr(k) = temp(i)
        k = k+1
    next
    ' Rest of j..hi is in place so no need to copy
end sub

sub insertsort(byref arr(), byval lo, byval hi)
    dim i, j, saved
    for i = lo+1 to hi
        saved = arr(i)
        j = i-1
        do until j < lo
            if arr(j) > saved then
                arr(j+1) = arr(j)
                j = j-1
            else
                exit do
            end if
        loop
        arr(j+1) = saved
    next
end sub

function issorted(byref arr)
    dim i
    for i = 0 to ubound(arr)-1
        if arr(i+1) < arr(i) then
            issorted = false
            exit function
        end if
    next
    issorted = true
end function

call main()
