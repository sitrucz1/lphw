'
' Mergesort - An algorithm to sort numbers by merging.
'

option explicit

sub main()
    ' dim arr, temp : arr = array(10,9,8,7,6,5,4,3,2,1)
    ' dim arr, temp : arr = array(2,3)
    ' dim arr, temp : arr = array(3,3,5,4,1,2,4,4,3,3)
    ' dim arr, temp : arr = array(1,2,3,4,5,6,7,8,9,10)
    dim arr, temp
    dim i, tstart, tend, tsum : tsum = 0
    for i = 1 to 25
        arr = makerandomarray(50000, 1, 100000)
        redim temp(ubound(arr))
        if ubound(arr) < 50 then
            wscript.echo join(arr)
        end if
        tstart = timer
        ' insertsort arr, 0, ubound(arr)
        ' shellsort arr, 0, ubound(arr)
        ' mergesorti arr, temp
        ' mergesort arr, temp, 0, ubound(arr)
        ' quicksortbasic arr, 0, ubound(arr)
        ' quicksortpivot arr, 0, ubound(arr)
        quicksortpivotsent arr, 0, ubound(arr)
        ' quicksortpivotmid arr, 0, ubound(arr)
        ' quicksortpivotmedian3 arr, 0, ubound(arr)
        ' quicksort arr, 0, ubound(arr)
        ' quicksortdf arr, 0, ubound(arr)
        ' quicksortbent arr, 0, ubound(arr)
        tend = timer
        tsum = tsum + (tend-tstart)
        if ubound(arr) < 50 then
            wscript.echo join(arr)
        end if
        wscript.echo "" & issorted(arr)
    next
    wscript.echo tsum / 25
end sub

function makerandomarray(byval n, byval lo, byval hi)
    dim i, arr : redim arr(n-1)
    randomize
    for i = 0 to n-1
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

sub quicksortdf(byref arr(), byval lo, byval hi)
    if lo >= hi then: exit sub :end if
    dim k, i, j, p, temp : k = lo : i = lo : j = hi : p = arr(lo+(hi-lo)\2)
    do until k > j
        if arr(k) < p then
            temp = arr(k) : arr(k) = arr(i) : arr(i) = temp
            i = i+1
            k = k+1
        elseif arr(k) > p then
            temp = arr(k) : arr(k) = arr(j) : arr(j) = temp
            j = j-1
        else
            k = k+1
        end if
    loop
    if lo < i-1 then: quicksortdf arr, lo, i-1 :end if
    if j+1 < hi then: quicksortdf arr, j+1, hi :end if
end sub

sub quicksortbasic(byref arr(), byval lo, byval hi)
    if lo >= hi then: exit sub :end if
    dim i, j, p, temp : p = arr(lo+(hi-lo)\2) : i = lo : j = hi
    do while i <= j
        do while arr(i) < p: i = i+1 :loop
        do while p < arr(j): j = j-1 :loop
        if i > j then: exit do :end if
        temp = arr(i) : arr(i) = arr(j) : arr(j) = temp
        i = i+1
        j = j-1
    loop
    if lo < j then: quicksortbasic arr, lo, j :end if
    if i < hi then: quicksortbasic arr, i, hi :end if
end sub

sub quicksortpivot(byref arr(), byval lo, byval hi)
    if lo >= hi then: exit sub :end if
    dim i, j, p, temp : i = lo : j = hi+1 : p = arr(lo)
    do
        do: i = i+1
            if i = hi then: exit do :end if
        loop while arr(i) < p
        do: j = j-1 :loop while p < arr(j)
        if i >= j then: exit do :end if
        temp = arr(i) : arr(i) = arr(j) : arr(j) = temp
    loop while true
    arr(lo) = arr(j) : arr(j) = p
    if lo < j-1 then: quicksortpivot arr, lo, j-1 :end if
    if j+1 < hi then: quicksortpivot arr, j+1, hi :end if
end sub

sub quicksortpivotsent(byref arr(), byval lo, byval hi)
    if lo >= hi then: exit sub :end if
    dim i, j, p, temp : i = lo : j = hi+1
    if arr(lo) > arr(hi) then
        temp = arr(lo) : arr(lo) = arr(hi) : arr(hi) = temp
    end if
    if lo+1 = hi then: exit sub :end if
    p = arr(lo)
    do
        do: i = i+1 :loop while arr(i) < p
        do: j = j-1 :loop while p < arr(j)
        if i >= j then: exit do :end if
        temp = arr(i) : arr(i) = arr(j) : arr(j) = temp
    loop while true
    arr(lo) = arr(j) : arr(j) = p
    if lo < j-1 then: quicksortpivotsent arr, lo, j-1 :end if
    if j+1 < hi then: quicksortpivotsent arr, j+1, hi :end if
end sub

sub quicksortpivotmid(byref arr(), byval lo, byval hi)
    if lo >= hi then: exit sub :end if
    dim i, j, mi, p, temp : i = lo : j = hi+1 : mi = lo+(hi-lo)\2
    temp = arr(lo) : arr(lo) = arr(mi) : arr(mi) = temp
    p = arr(lo)
    do
        do: i = i+1
            if i = hi then: exit do :end if
        loop while arr(i) < p
        do: j = j-1 :loop while p < arr(j)
        if i >= j then: exit do :end if
        temp = arr(i) : arr(i) = arr(j) : arr(j) = temp
    loop while true
    arr(lo) = arr(j) : arr(j) = p
    if lo < j-1 then: quicksortpivotmid arr, lo, j-1 :end if
    if j+1 < hi then: quicksortpivotmid arr, j+1, hi :end if
end sub

sub quicksortpivotmedian3(byref arr(), byval lo, byval hi)
    if lo >= hi then: exit sub :end if
    dim i, j, mi, p, temp : i = lo : j = hi+1 : p = lo+1
    if hi-lo > 40 then
        mi = lo+(hi-lo)\2 : p = lo+1
        temp = arr(p) : arr(p) = arr(mi) : arr(mi) = temp
        if arr(p) < arr(lo) then
            temp = arr(p) : arr(p) = arr(lo) : arr(lo) = temp
        end if
        if arr(p) < arr(hi) then
            temp = arr(p) : arr(p) = arr(hi) : arr(hi) = temp
        end if
        if arr(lo) > arr(hi) then
            temp = arr(lo) : arr(lo) = arr(hi) : arr(hi) = temp
        end if
    else
        if arr(lo) > arr(hi) then ' sentinel
            temp = arr(lo) : arr(lo) = arr(hi) : arr(hi) = temp
            if p = hi then: exit sub :end if
        end if
    end if
    p = arr(lo)
    do
        do: i = i+1 :loop while arr(i) < p
        do: j = j-1 :loop while p < arr(j)
        if i >= j then: exit do :end if
        temp = arr(i) : arr(i) = arr(j) : arr(j) = temp
    loop while true
    arr(lo) = arr(j) : arr(j) = p
    if lo < j-1 then: quicksortpivotmedian3 arr, lo, j-1 :end if
    if j+1 < hi then: quicksortpivotmedian3 arr, j+1, hi :end if
end sub

sub quicksort(byref arr(), byval lo, byval hi)
    if lo >= hi then: exit sub :end if
    dim i, j, p, ip, jp, temp, n, mi : n = hi-lo
    if n < 7 then
        for i = lo+1 to hi
            p = arr(i)
            j = i
            do while j > lo
                if arr(j-1) > p then
                    arr(j) = arr(j-1)
                    j = j-1
                else
                    exit do
                end if
            loop
            arr(j) = p
        next
        exit sub
    end if
    mi = lo+n\2
    if n > 40 then
        if arr(lo) < arr(mi) then
            temp = arr(lo) : arr(lo) = arr(mi) : arr(mi) = temp
        end if
        if arr(lo) < arr(hi) then
            temp = arr(lo) : arr(lo) = arr(hi) : arr(hi) = temp
        end if
        if arr(mi) < arr(hi) then
            temp = arr(mi) : arr(mi) = arr(hi) : arr(hi) = temp
        end if
    end if
    p = arr(mi) : i = lo-1 : j = hi+1 : ip = i : jp = j
    do
        ' wscript.echo i, j, p
        do: i = i+1 :loop while arr(i) < p
        do: j = j-1 :loop while p < arr(j)
        if i = j then
            if arr(i) = p then
                ip = ip+1
                temp = arr(i) : arr(i) = arr(ip) : arr(ip) = temp
            end if
        end if
        if i >= j then: exit do :end if
        temp = arr(i) : arr(i) = arr(j) : arr(j) = temp
        if arr(i) = p then
            ip = ip+1
            temp = arr(i) : arr(i) = arr(ip) : arr(ip) = temp
        end if
        if arr(j) = p then
            jp = jp-1
            temp = arr(j) : arr(j) = arr(jp) : arr(jp) = temp
        end if
    loop until false
    dim k : i = j+1
    for k = lo to ip
        temp = arr(k) : arr(k) = arr(j) : arr(j) = temp
        j = j-1
    next
    for k = jp to hi
        temp = arr(k) : arr(k) = arr(i) : arr(i) = temp
        i = i+1
    next
    ' wscript.echo join(arr)
    if lo < j then: quicksort arr, lo, j :end if
    if i < hi then: quicksort arr, i, hi :end if
end sub

sub quicksortbent(byref arr(), byval lo, byval hi)
    if lo >= hi then: exit sub :end if
    dim i, j, p, ip, jp, temp, n, mi : n = hi-lo
    if n < 7 then
        for i = lo+1 to hi
            p = arr(i)
            j = i
            do while j > lo
                if arr(j-1) > p then
                    arr(j) = arr(j-1)
                    j = j-1
                else
                    exit do
                end if
            loop
            arr(j) = p
        next
        exit sub
    end if
    mi = lo+n\2
    if n > 40 then
        if arr(lo) < arr(mi) then
            temp = arr(lo) : arr(lo) = arr(mi) : arr(mi) = temp
        end if
        if arr(lo) < arr(hi) then
            temp = arr(lo) : arr(lo) = arr(hi) : arr(hi) = temp
        end if
        if arr(mi) < arr(hi) then
            temp = arr(mi) : arr(mi) = arr(hi) : arr(hi) = temp
        end if
    end if
    p = arr(mi) : i = lo : j = hi : ip = lo : jp = hi
    do while i <= j
        ' wscript.echo i, j, p
        do until i > jp
            if arr(i) > p then: exit do :end if
            if arr(i) = p then
                temp = arr(i) : arr(i) = arr(ip) : arr(ip) = temp
                ip = ip+1
            end if
            i = i+1
        loop
        do until j < ip
            if arr(j) < p then: exit do :end if
            if arr(j) = p then
                temp = arr(j) : arr(j) = arr(jp) : arr(jp) = temp
                jp = jp-1
            end if
            j = j-1
        loop
        if i > j then: exit do :end if
        temp = arr(i) : arr(i) = arr(j) : arr(j) = temp
        i = i+1
        j = j-1
    loop
    dim k
    for k = lo to ip-1
        temp = arr(k) : arr(k) = arr(j) : arr(j) = temp
        j = j-1
    next
    for k = jp+1 to hi
        temp = arr(k) : arr(k) = arr(i) : arr(i) = temp
        i = i+1
    next
    ' wscript.echo join(arr)
    if lo < j then: quicksortbent arr, lo, j :end if
    if i < hi then: quicksortbent arr, i, hi :end if
end sub

sub mergesorti(byref arr(), byref temp())
    dim wid, n : wid = 1 : n = ubound(arr)
    do until wid > n
        dim lo : lo = 0
        do until lo > n-wid
            dim mi, hi : mi = lo+wid-1 : hi = mi+wid
            if hi > n then: hi = n :end if
            if arr(mi) > arr(mi+1) then: merge arr, temp, lo, mi, hi :end if
            lo = hi+1
        loop
        wid = wid+wid
    loop
end sub

sub mergesort(byref arr(), byref temp(), byval lo, byval hi)
    if lo < hi then
        dim mi : mi = lo + (hi - lo) \ 2
        mergesort arr, temp, lo, mi
        mergesort arr, temp, mi+1, hi
        if arr(mi) > arr(mi+1) then: merge arr, temp, lo, mi, hi :end if
    end if
end sub

sub merge(byref arr(), byref temp(), byval lo, byval mi, byval hi)
    dim k
    ' make a copy of the array so we can replace it
    for k = lo to hi
        temp(k) = arr(k)
    next
    ' merge temp i..mi, j..hi to arr
    dim i, j : i = lo : j = mi+1
    for k = lo to hi
        if i > mi then
            arr(k) = temp(j)
            j = j+1
        elseif j > hi then
            arr(k) = temp(i)
            i = i+1
        elseif temp(i) <= temp(j) then
            arr(k) = temp(i)
            i = i+1
        else
            arr(k) = temp(j)
            j = j+1
        end if
    next
end sub

sub insertsort(byref arr(), byval lo, byval hi)
    dim i, j, saved
    for i = lo+1 to hi
        saved = arr(i)
        j = i
        do while j > lo
            if arr(j-1) > saved then
                arr(j) = arr(j-1)
                j = j-1
            else
                exit do
            end if
        loop
        arr(j) = saved
    next
end sub

sub shellsort(byref arr(), byval lo, byval hi)
    dim i, j, k, gap, gaps, saved : gaps = array(1,4,13,40,121,364,1093,3280,9841,29524)
    for k = ubound(gaps) to 0 step -1
        gap = gaps(k)
        for i = lo+gap to hi
            saved = arr(i)
            j = i
            do while j-gap >= lo
                if arr(j-gap) > saved then
                    arr(j) = arr(j-gap)
                    j = j-gap
                else
                    exit do
                end if
            loop
            arr(j) = saved
        next
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
