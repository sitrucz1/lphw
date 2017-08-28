'
' Queue and Stack data structure
'

' option explicit

' sub main()
'     dim queue : set queue = new tqueue
'     queue.enqueue("a")
'     queue.enqueue("b")
'     ' queue.dequeue()
'     wscript.echo queue.peek()
'     queue.enqueue("c")
'     queue.print()
'     wscript.echo queue.length()
'     do until queue.isempty()
'         queue.dequeue()
'     loop

'     dim stack : set stack = new tstack
'     stack.push("a")
'     stack.push("b")
'     stack.push("c")
'     stack.peek()
'     stack.print()
'     wscript.echo stack.length()
'     do until stack.isempty()
'         stack.pop()
'     loop
' end sub

class tllitem

    public m_item
    public m_next

    private sub class_initialize()
        set m_item = nothing
        set m_next = nothing
    end sub

    public function init(item)
        if vartype(item) = vbobject then
            set m_item = item
        else
            m_item = item
        end if
        set m_next = nothing
        set init = me
    end function

end class

class tqueue

    private m_head
    private m_tail
    private m_cnt

    private sub class_initialize()
        set m_head = nothing
        set m_tail = nothing
        m_cnt  = 0
    end sub

    public function isfull()
        isfull = false
    end function

    public function isempty()
        isempty = (m_cnt = 0)
    end function

    public function length()
        length = m_cnt
    end function

    public function enqueue(m_item)
        dim node : set node = (new tllitem).init(m_item)
        if isempty() then
            set m_head = node
            set m_tail = node
        else
            set m_tail.m_next = node
            set m_tail = m_tail.m_next
        end if
        m_cnt = m_cnt+1
        if vartype(m_item) = vbobject then
            set enqueue = m_item
        else
            enqueue = m_item
        end if
    end function

    public function dequeue()
        if isempty() then
            exit function
        end if
        dim node : set node = m_head
        set m_head = m_head.m_next
        if m_head is nothing then
            set m_tail = nothing
        end if
        m_cnt = m_cnt-1
        if vartype(node.m_item) = vbobject then
            set dequeue = node.m_item
        else
            dequeue = node.m_item
        end if
    end function

    public function peek()
        if isempty() then
            exit function
        end if
        if vartype(m_head.m_item) = vbobject then
            set peek = m_head.m_item
        else
            peek = m_head.m_item
        end if
    end function

    public sub print()
        dim curr : set curr = m_head
        do until curr is nothing
            if vartype(curr.m_item) = vbobject then
                wscript.echo "Object"
            else
                wscript.echo curr.m_item
            end if
            set curr = curr.m_next
        loop
    end sub

end class

class tstack

    private m_head
    private m_cnt

    private sub class_initialize
        set m_head = nothing
        m_cnt = 0
    end sub

    public function isfull()
        isfull = false
    end function

    public function isempty()
        isempty = (m_cnt = 0)
    end function

    public function length()
        length = m_cnt
    end function

    public function push(m_item)
        dim node : set node = (new tllitem).init(m_item)
        set node.m_next = m_head
        set m_head = node
        m_cnt = m_cnt+1
        if vartype(m_item) = vbobject then
            set push = m_item
        else
            push = m_item
        end if
    end function

    public function pop()
        if isempty() then
            exit function
        end if
        dim node : set node = m_head
        set m_head = m_head.m_next
        m_cnt = m_cnt-1
        if vartype(node.m_item) = vbobject then
            set pop = node.m_item
        else
            pop = node.m_item
        end if
    end function

    public function peek()
        if isempty() then
            exit function
        end if
        if vartype(m_head.m_item) = vbobject then
            set peek = m_head.m_item
        else
            peek = m_head.m_item
        end if
    end function

    public sub print()
        dim curr : set curr = m_head
        do until curr is nothing
            if vartype(curr.m_item) = vbobject then
                wscript.echo "Object"
            else
                wscript.echo curr.m_item
            end if
            set curr = curr.m_next
        loop
    end sub

end class

' call main()
