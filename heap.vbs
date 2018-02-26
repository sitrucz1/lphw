'
' Heap Data Structure - An implementation in VBScript
' Curtis Matz
'

option explicit

sub main()
    dim heap : set heap = (new theap).init(1000, vbnull)
    heap.enqueue(5)
    heap.enqueue(10)
    wscript.echo heap.dequeue
end sub

class theap

    private m_items
    private m_size
    private m_cnt
    public m_comparefunc

    public function init(byval initsize, byref compfunc)
        m_items = array()
        redim m_items(initsize-1)
        m_size = initsize
        m_cnt = 0
        ' if isnull(compfunc) then
            set m_comparefunc = getref("comparefunc")
        ' else
        '     m_comparefunc = compfunc
        ' end if
        set init = me
    end function

    public function comparefunc(byval a, byval b)
        if a < b then
            comparefunc = -1
        elseif a = b then
            comparefunc = 0
        else
            comparefunc = 1
        end if
    end function

    public function isheap
        dim child
        for child = cnt-1 to 1 step -1
            dim root : root = (child-1) \ 2
            if comparefunc(m_items(root), m_items(child)) < 0 then
                wscript.echo "Parent and child mismatch: ", root, child
                isheap = false
                exit function
            end if
        next
        isheap = true
    end function

    public function isfull
        isfull = false
    end function

    public function isempty
        isempty = (m_cnt = 0)
    end function

    public function enqueue(byval item)
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
        enqueue = true
    end function

    public function dequeue
        if isobject(m_items(0)) then
            set dequeue = m_items(0)
        else
            dequeue = m_items(0)
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
                if m_comparefunc(arr(child+1), arr(child)) > 0 then
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

    sub siftup(byval child)
        dim parent, saved
        if isobject(m_items(child)) then
            set saved = m_items(child)
        else
            saved = m_items(child)
        end if
        do while child > 0
            parent = (child-1) \ 2
            if m_comparefunc(m_items(parent), saved) >= 0 then
                break
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

    sub heapify(byval cnt)
        dim root
        for root = (cnt-2) \ 2 to 0 step -1
            siftdown root
        next
    end sub

end class

call main()
