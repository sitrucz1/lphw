'
' Lists - An arraylist example
'

option explicit

sub main()
    dim item, list : set list = createobject("System.Collections.ArrayList")
    list.add 5
    list.add 6
    list.add 2
    wscript.echo list.count
    for each item in list
        wscript.echo item
    next
    wscript.echo join(list.toarray, " ")
end sub

call main()
