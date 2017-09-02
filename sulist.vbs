option explicit

class vblist

    private marr()
    private mcnt
    private mmaxsize

    private sub class_initialize
        mcnt = 0
        mmaxsize = 0
    end sub

    public function init(n)
        redim marr(n)
        mcnt = 0
        mmaxsize = n
        set init = me
    end function

    public function contains(item)
        wscript.echo mcnt, mmaxsize, item
        if mcnt >= mmaxsize then
            contains = false
            exit function
        end if
        dim lo, hi, mi : lo = 0 : hi = mcnt-1
        do while lo <= hi
            mi = lo+(hi-lo)\2
            wscript.echo " ", lo, hi, mi
            if item = marr(mi) then
                wscript.echo "found it"
                contains = true
                exit function
            elseif item < marr(mi) then
                hi = mi-1
            else
                lo = mi+1
            end if
        loop
        contains = false
    end function
    
    public function put(item)
        if mcnt+1 > mmaxsize then
            put = false
            exit function
        end if
        if contains(item) then
            put = true
            exit function
        end if
        mcnt = mcnt+1
        dim i : i = mcnt-1
        do while i > 0
            if item > marr(i-1) then
                exit do
            end if
            marr(i) = marr(i-1)
            i = i-1
        loop
        marr(i) = item
        put = true
    end function

    public function length
        length = mcnt
    end function

end class

dim test, i, myarr : myarr = array(0, 1, 2, 3, 2, 1, 5, 5)
set test=(new vblist).init(20)
for i = lbound(myarr) to ubound(myarr)
    if test.put(myarr(i)) then
        wscript.echo "yes"
    else
        wscript.echo "no"
    end if
next
wscript.echo test.length
