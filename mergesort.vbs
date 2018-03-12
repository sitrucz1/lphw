'
' Mergesort - An algorithm to sort numbers by merging.
'

option explicit

sub main()
    ' dim arr : arr = array(10,9,8,7,6,5,4,3,2,1)
    dim arr : arr = makerandomarray(1, 15)
    wscript.echo join(arr)
    mergesort arr, 0, ubound(arr)
    wscript.echo join(arr)
end sub

function makerandomarray(byval lo, byval hi)
    dim i, arr : redim arr(hi-lo)
    randomize
    for i = 0 to hi-lo
        arr(i) = int((hi-lo+1) * rnd + lo)
    next
    makerandomarray = arr
end function

sub mergesort(byref arr(), byval lo, byval hi)
    if lo < hi then
        dim mi : mi = lo + (hi - lo) \ 2
        mergesort arr, lo, mi
        mergesort arr, mi+1, hi
        ' wscript.echo "lo, mi, hi: ", lo, mi, hi
        merge arr, lo, mi, hi
        ' wscript.echo join(arr)
    end if
end sub

sub merge(byref arr(), byval lo, byval mi, byval hi)
    dim k, temp : redim temp(hi-lo)
    ' make a copy of the array so we can replace it
    for k = lo to hi
        temp(k-lo) = arr(k)
    next
    ' merge temp i..mi, j..hi to arr
    dim i, j : i = lo : j = mi+1
    for k = lo to hi
        if i > mi then
            arr(k) = temp(j-lo)
            j = j+1
        elseif j > hi then
            arr(k) = temp(i-lo)
            i = i+1
        elseif temp(i-lo) <= temp(j-lo) then
            arr(k) = temp(i-lo)
            i = i+1
        else
            arr(k) = temp(j-lo)
            j = j+1
        end if
    next
    ' cleanup
    erase temp
end sub

call main()
