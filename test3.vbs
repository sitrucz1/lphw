option explicit

const ITER = 100000
const N = 2048

sub main()
    dim arr(), i, x : redim arr(N)
    randomize timer
    for i = 0 to ubound(arr)
        arr(i) = i
    next
    x = timer
    for i = 1 to ITER
        call lsearch(arr, int(rnd()*N))
    next
    wscript.echo "Linear => ", timer-x
    x = timer
    for i = 1 to ITER
        call bsearch(arr, int(rnd*N))
    next
    wscript.echo "Binary => ", timer-x
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
