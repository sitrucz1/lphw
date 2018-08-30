option explicit

const ITER = 100000
const N = 2048

sub main
    dim arr(), i, x : redim arr(N)
    dim t(2), tstart, tend : t(0) = 0 : t(1) = 0 : t(2) = 0
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
    next
    for i = 0 to 2
        wscript.echo i, t(i)
    next
end sub

function bsearch(byref arr(), byval v)
    dim k, l, r : l = lbound(arr) : r = ubound(arr)
    do while l < r
        k = l + (r-l) \ 2
        if v = arr(k) then
            bsearch = k
            exit function
        end if
        if v < arr(k) then
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
