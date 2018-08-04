'
' Dutch Flag Problem
'

option explicit

sub main()
    ' dim arr : arr = array(3,1,2,2,3,1,1,3,3,2)
    dim arr : arr = makearray(40)
    wscript.echo join(arr)
    dfs arr
    wscript.echo join(arr)
    wscript.echo "" & isdf(arr)
end sub

sub dfs(byref arr())
    dim k, lo, hi, temp : k = 0 : lo = 0 : hi = ubound(arr)
    do until k > hi
        if arr(k) < 2 then
            temp = arr(k) : arr(k) = arr(lo) : arr(lo) = temp
            lo = lo+1
            k = k+1
        elseif arr(k) > 2 then
            temp = arr(k) : arr(k) = arr(hi) : arr(hi) = temp
            hi = hi-1
        else
            k = k+1
        end if
    loop
end sub

function makearray(byval n)
    dim i, arr : redim arr(n-1)
    randomize
    for i = 0 to n-1
        arr(i) = int(3*rnd)+1
    next
    makearray = arr
end function

function isdf(byref arr())
    dim i
    for i = 1 to ubound(arr)
        if arr(i) < arr(i-1) then
            isdf = false
            exit function
        end if
    next
    isdf = true
end function

call main()
