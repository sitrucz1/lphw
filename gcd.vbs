option explicit

sub main()
    wscript.echo gcd(14, 49)
    wscript.echo lcm(14, 49)
end sub

function gcd(byval a, byval b)
    if b = 0 then
        gcd = a
    else
        gcd = gcd(b, a mod b)
    end if
end function

function lcm(byval a, byval b)
    dim x : x = gcd(a, b)
    if x = 0 then
        lcm = 0
    else
        lcm = a*b \ x
    end if
end function

call main
