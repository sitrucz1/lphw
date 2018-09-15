option explicit

const ITER = 50000
const N = 4096

sub main
    dim arr(), i, x : redim arr(N)
    dim t(3), tstart, tend : t(0) = 0 : t(1) = 0 : t(2) = 0 : t(3) = 0
    randomize timer
    for i = 0 to ubound(arr)
        arr(i) = i
    next

    for i = 1 to ITER
        dim r : r = int(rnd*N)
        tstart = timer
        ' call lsearch(arr, r)
        tend = timer
        t(0) = t(0) + tend-tstart
        tstart = timer
        call bsearch(arr, r)
        tend = timer
        t(1) = t(1) + tend-tstart
        tstart = timer
        call bsearch2(arr, r)
        tend = timer
        t(2) = t(2) + tend-tstart
        tstart = timer
        call bsearchr(arr, r, lbound(arr), ubound(arr))
        tend = timer
        t(3) = t(3) + tend-tstart
    next
    for i = lbound(t) to ubound(t)
        wscript.echo i, t(i)
    next
end sub

function bsearchr(byref arr(), byval v, byval l, byval r)
    if l > r then
        bsearchr = l
    else
        dim k : k = l+(r-l)\2
        if v < arr(k) then
            bsearchr = bsearchr(arr, v, l, k-1)
        elseif v > arr(k) then
            bsearchr = bsearchr(arr, v, k+1, r)
        else
            bsearchr = k
        end if
    end if
end function

function bsearch(byref arr(), byval v)
    dim k, l, r : l = lbound(arr) : r = ubound(arr)
    do while l <= r
        k = l+(r-l)\2
        if v < arr(k) then
            r = k-1
        elseif v > arr(k) then
            l = k+1
        else
            bsearch = k
            exit function
        end if
    loop
    bsearch = l
end function

function bsearch2(byref arr(), byval v)
    dim k, l, r : l = lbound(arr) : r = ubound(arr)
    do while l < r
        k = l + (r-l) \ 2
        if v < arr(l) then
            bsearch2 = l
            exit function
        elseif v > arr(r) then
            bsearch2 = r+1
            exit function
        elseif v = arr(k) then
            bsearch2 = k
            exit function
        elseif v = arr(l) then
            bsearch2 = l
            exit function
        elseif v = arr(r) then
            bsearch2 = r
            exit function
        elseif v < arr(k) then
            r = k-1
        else
            l = k+1
        end if
    loop
    if v > arr(l) then
        bsearch = l+1
    else
        bsearch = l
    end if
end function

function lsearch(byref arr(), byval v)
    dim k : k = 0
    do while k <= ubound(arr)
        if v > arr(k) then
            k = k+1
        else
            exit do
        end if
    loop
    lsearch = k
end function

call main
