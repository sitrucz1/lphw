option explicit

sub main()
    dim a, b
    a = array(1, 2, 2, 2, 4, 5, 7)
    b = array(2, 2, 5, 5, 8, 8)
    wscript.echo "A => { " & join(a) & " }  B => { " & join(b) & " }"
    union a, b
    intersection a, b
    minus a, b
end sub

sub union(byref a, byref b)
    ' wscript.echo lbound(a), ubound(a)
    dim i, j, iend, jend, prev
    i = 0 : j = 0 : iend = ubound(a) : jend = ubound(b) : prev = -1
    do while (i <= iend) and (j <= jend)
        if a(i) < b(j) then
            if a(i) <> prev then
                wscript.stdout.write a(i)
            end if
            prev = a(i)
            i = i+1
        elseif b(j) < a(i) then
            if b(j) <> prev then
                wscript.stdout.write b(j)
            end if
            prev = b(j)
            j = j+1
        else
            if a(i) <> prev then
                wscript.stdout.write a(i)
            end if
            prev = a(i)
            i = i+1
            j = j+1
        end if
    loop
    for i = i to iend
        if a(i) <> prev then
            wscript.stdout.write a(i)
        end if
        prev = a(i)
    next
    for j = j to jend
        if b(j) <> prev then
            wscript.stdout.write b(j)
        end if
        prev = b(j)
    next
    wscript.stdout.writeline
end sub

sub intersection(byref a, byref b)
    dim i, j, iend, jend, prev
    i = 0 : j = 0 : iend = ubound(a) : jend = ubound(b) : prev = -1
    do while (i <= iend) and (j <= jend)
        if a(i) < b(j) then
            i = i+1
        elseif b(j) < a(i) then
            j = j+1
        else
            if a(i) <> prev then
                wscript.stdout.write a(i)
            end if
            prev = a(i)
            i = i+1
            j = j+1
        end if
    loop
    wscript.stdout.writeline
end sub

sub minus(byref a, byref b)
    dim i, lo, hi, mid, prev
    prev = -1
    for i = 0 to ubound(a)
        lo = 0
        hi = ubound(b)
        mid = lo+(hi-lo)\2
        do while (lo < hi) and (a(i) <> b(mid))
            if a(i) < b(mid) then
                hi = mid-1
            else
                lo = mid+1
            end if
            mid = lo+(hi-lo)\2
        loop
        if (a(i) <> b(mid)) and (a(i) <> prev) then
            wscript.stdout.write a(i)
            prev = a(i)
        end if
    next
    wscript.stdout.writeline
end sub

call main()
