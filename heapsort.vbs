'
' Heapsort - An implementation in VBScript
' Curtis Matz
'

option explicit

sub main()
    dim cnt, arr() : cnt = 25 : initarr arr, cnt    ' dynamic random array
    ' dim cnt, arr : cnt = 10 : arr = array(67, 88, 92, 26, 50, 93, 40, 8, 48, 96)
    printarr arr
    wscript.echo isheap(arr, cnt)
    heapify arr, cnt
    printarr arr
    wscript.echo isheap(arr, cnt)
    heapsort arr, cnt
    printarr arr
end sub

sub initarr(byref arr(), byval cnt)
    redim arr(cnt)
    randomize timer
    dim i
    for i = 0 to cnt - 1
        arr(i) = int(100 * rnd + 1)
    next
end sub

sub printarr(byref arr())
    if ubound(arr) <= 25 then
        dim num
        for each num in arr
            wscript.stdout.write num & " "
        next
        wscript.echo ""
    end if
end sub

function isheap(byref arr(), byval cnt)
    dim child
    for child = cnt-1 to 1 step -1
        dim root : root = (child-1) \ 2
        if arr(root) < arr(child) then
            wscript.echo "Parent and child mismatch: ", root, child
            isheap = false
            exit function
        end if
    next
    isheap = true
end function

sub siftdown(byref arr(), byval root, byval cnt)
    dim saved : saved = arr(root)
    dim child : child = root*2+1
    do while child < cnt
        if child+1 < cnt then   ' No short circuit boolean logic
            if arr(child+1) > arr(child) then
                child = child+1
            end if
        end if
        if saved >= arr(child) then
            exit do
        end if
        arr(root) = arr(child)
        root = child
        child = root*2+1
    loop
    arr(root) = saved
end sub

sub siftup(byref arr(), byval child)
    dim parent, saved
    saved = arr(child)
    do while child > 0
        parent = (child-1) \ 2
        if arr(parent) >= saved then
            break
        end if
        arr(child) = arr(parent)
        child = parent
    loop
    arr(child) = saved
end sub

sub heapify(byref arr(), byval cnt)
    dim root
    for root = (cnt-2) \ 2 to 0 step -1
        siftdown arr, root, cnt
    next
end sub

sub heapsort(byref arr(), byval cnt)
    heapify arr, cnt
    dim i
    for i = cnt-1 to 1 step -1
        dim temp : temp = arr(i) : arr(i) = arr(0) : arr(0) = temp  ' swap
        siftdown arr, 0, i
    next
end sub

call main()
