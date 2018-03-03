'
' Heap Data Structure Test Script - An implementation in VBScript
' Curtis Matz
'

option explicit

includefile "heap.vbs"      ' theap

sub main()
    dim heap : set heap = (new theap).init(1000, getref("mycompare"))
    dim arr : arr = array(5,10,3,13,12,9,2)
    heap.makeheap arr, ubound(arr)+1, true
    ' heap.push((new tdata).init(5))
    ' heap.push((new tdata).init(10))
    ' heap.push((new tdata).init(3))
    ' heap.push((new tdata).init(13))
    ' heap.push((new tdata).init(12))
    ' ' heap.heapify
    wscript.echo heap.peek
    wscript.echo heap.isheap
    wscript.echo "length is: " & heap.length
    do while not heap.isempty
        wscript.echo heap.pop
        wscript.echo heap.isheap
    loop
end sub

sub includefile(fspec)
    executeglobal createobject("scripting.filesystemobject").opentextfile(fspec).readall()
end sub

function mycompare(byval a, byval b)
    ' Min heap: less than should be equal to 1.  Max heap: Greater than should be equal to 1.
    if a < b then
        mycompare = 1
    elseif a > b then
        mycompare = -1
    else
        mycompare = 0
    end if
end function

class tdata

    public m_data

    public function init(byval data)
        m_data = data
        set init = me
    end function

end class

call main()
