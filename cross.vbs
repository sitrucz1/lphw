option explicit

sub main()
    dim digits, columns : digits = "123456789" : columns = "ABCDEFGHI"
    cross columns, digits
end sub

sub cross(a, b)
    dim i, j, list
    set list = createobject("system.collections.arraylist")
    for i=1 to len(a)
        for j=1 to len(b)
            ' wscript.stdout.write(mid(a,i,1) & mid(b,j,1) & " ")
            list.add mid(a,i,1) & mid(b,j,1)
        next
    next
    ' wscript.stdout.writeline
    wscript.echo join(list.toarray())
end sub

call main()
