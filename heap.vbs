'
' Heap Data Structure - An implementation in VBScript
' Curtis Matz
'

option explicit

' sub main()
'     dim heap : set heap = (new theap).init(1000, getref("mycompare"))
'     dim arr : arr = array(5,10,3,13,12,9,2)
'     heap.makeheap arr, ubound(arr)+1, true
'     ' heap.push((new tdata).init(5))
'     ' heap.push((new tdata).init(10))
'     ' heap.push((new tdata).init(3))
'     ' heap.push((new tdata).init(13))
'     ' heap.push((new tdata).init(12))
'     ' ' heap.heapify
'     wscript.echo heap.peek
'     wscript.echo heap.isheap
'     wscript.echo "length is: " & heap.length
'     do while not heap.isempty
'         wscript.echo heap.pop
'         wscript.echo heap.isheap
'     loop
' end sub

' function mycompare(byval a, byval b)
'     ' Min heap: less than should be equal to 1.  Max heap: Greater than should be equal to 1.
'     if a < b then
'         mycompare = 1
'     elseif a > b then
'         mycompare = -1
'     else
'         mycompare = 0
'     end if
' end function

' class tdata

'     public m_data

'     public function init(byval data)
'         m_data = data
'         set init = me
'     end function

' end class

class theap

    private m_items
    private m_size
    private m_cnt
    private m_comparefunc   ' use getref("mycomparefunc") in a non-class function

    public function init(byval initsize, byref comparefunc)
        m_items = array()
        redim m_items(initsize-1)
        m_size = initsize
        m_cnt = 0
        set m_comparefunc = comparefunc
        set init = me
    end function

    public function isheap
        dim child
        for child = m_cnt-1 to 1 step -1
            dim root : root = (child-1) \ 2
            if m_comparefunc(m_items(root), m_items(child)) < 0 then
                wscript.echo "Parent and child mismatch: ", root, child
                isheap = false
                exit function
            end if
        next
        isheap = true
    end function

    public function isfull
        isfull = (m_cnt = m_size)
    end function

    public function isempty
        isempty = (m_cnt = 0)
    end function

    public function length
        length = m_cnt
    end function

    public function push(byval item)
        if isfull then
            m_size = m_size*2
            redim preserve m_items(m_size-1)
        end if
        if isobject(item) then
            set m_items(m_cnt) = item
        else
            m_items(m_cnt) = item
        end if
        siftup m_cnt
        m_cnt = m_cnt+1
        push = true
    end function

    public function pop
        if isobject(m_items(0)) then
            set pop = m_items(0)
        else
            pop = m_items(0)
        end if
        if isobject(m_items(m_cnt-1)) then
            set m_items(0) = m_items(m_cnt-1)
        else
            m_items(0) = m_items(m_cnt-1)
        end if
        m_cnt = m_cnt-1
        siftdown 0
    end function

    public function peek
        if isobject(m_items(0)) then
            set peek = m_items(0)
        else
            peek = m_items(0)
        end if
    end function

    private sub siftdown(byval root)
        dim saved, child
        child = root*2+1
        if isobject(m_items(root)) then
            set saved = m_items(root)
        else
            saved = m_items(root)
        end if
        do while child < m_cnt
            if child+1 < m_cnt then   ' No short circuit boolean logic
                if m_comparefunc(m_items(child+1), m_items(child)) > 0 then
                    child = child+1
                end if
            end if
            if m_comparefunc(saved, m_items(child)) >= 0 then
                exit do
            end if
            if isobject(m_items(child)) then
                set m_items(root) = m_items(child)
            else
                m_items(root) = m_items(child)
            end if
            root = child
            child = root*2+1
        loop
        if isobject(saved) then
            set m_items(root) = saved
        else
            m_items(root) = saved
        end if
    end sub

    private sub siftup(byval child)
        dim parent, saved
        if isobject(m_items(child)) then
            set saved = m_items(child)
        else
            saved = m_items(child)
        end if
        do while child > 0
            parent = (child-1) \ 2
            if m_comparefunc(m_items(parent), saved) >= 0 then
                exit do
            end if
            if isobject(m_items(parent)) then
                set m_items(child) = m_items(parent)
            else
                m_items(child) = m_items(parent)
            end if
            child = parent
        loop
        if isobject(saved) then
            set m_items(child) = saved
        else
            m_items(child) = saved
        end if
    end sub

    public sub makeheap(byref arr, byval cnt, byval expand)
        erase m_items
        m_items = arr
        if expand and ubound(m_items) < m_size then
            redim preserve m_items(m_size-1)
        end if
        m_size = ubound(m_items)+1
        m_cnt = cnt
        heapify
    end sub

    public sub heapify
        dim root
        for root = (m_cnt-2) \ 2 to 0 step -1
            siftdown root
        next
    end sub

end class

' call main()
