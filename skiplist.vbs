option explicit

const MAXLEVEL = 16
const ITER = 10

sub main()
    dim sl : set sl = (new tskiplist).init(0.5)
    dim node : set node = (new tnode).init(2, 5, sl.m_nil)
    dim i, j, a() : redim a(MAXLEVEL-1)
    for i = 0 to MAXLEVEL - 1
        a(i) = 0
    next
    for i = 0 to ITER-1
        j = sl.randlevel
        a(j-1) = a(j-1) + 1
    next
    for i = 0 to MAXLEVEL - 1
        wscript.echo i+1, a(i), a(i) / ITER
    next
    ' insert
    for i = 0 to ITER-1
        sl.slput(int(rnd()*100) + 1)
    next
    sl.slprint
    ' find
    for i = 1 to 5
        wscript.echo sl.slfind(int(rnd()*100) + 1)
    next
    ' delete
    do until sl.isempty
        sl.sldelete(sl.m_head.m_next(sl.m_level-1).m_data)
        sl.slprint
    loop
end sub

class tnode

    public m_data
    public m_next()

    public function init(byval data, byval level, byval nil)
        dim i
        m_data = data
        redim m_next(level-1)
        for i = 0 to level-1
            set m_next(i) = nil
        next
        set init = me
    end function

end class

class tskiplist

    public m_head
    public m_nil
    public m_level
    public m_prob
    public m_cnt

    public function init(byval prob)
        set m_nil = (new tnode).init(65535, MAXLEVEL, nothing)
        set m_head = (new tnode).init(-1, MAXLEVEL, m_nil)
        m_level = 1
        m_prob = prob
        m_cnt = 0
        randomize timer
        set init = me
    end function

    public function isempty
        isempty = m_cnt = 0
    end function

    function randlevel
        dim level
        level = 1
        do until rnd() > m_prob or level > MAXLEVEL
            level = level+1
        loop
        randlevel = level
    end function

    sub slprint
        dim k, node
        for k = m_level-1 to 0 step -1
            set node = m_head
            wscript.stdout.write k+1 & "=>"
            do until node is nothing
                wscript.stdout.write node.m_data & " "
                set node = node.m_next(k)
            loop
            wscript.stdout.writeline
        next
    end sub

    function slfind(byval data)
        wscript.echo "** Finding => ", data
        dim k, node
        set node = m_head
        for k = m_level-1 to 0 step -1
            do while node.m_next(k).m_data < data
                set node = node.m_next(k)
            loop
        next
        set node = node.m_next(0)
        slfind = node.m_data = data
    end function

    function slput(byval data)
        wscript.echo "** Inserting => ", data
        dim k, node, prev() : redim prev(MAXLEVEL-1)
        set node = m_head
        for k = m_level-1 to 0 step -1
            do while node.m_next(k).m_data < data
                set node = node.m_next(k)
            loop
            set prev(k) = node
        next
        set node = node.m_next(0)
        if node.m_data = data then ' found it
            node.m_data = data
        else ' insert it
            dim level : level = randlevel
            if level > m_level then
                for k = m_level to level-1
                    set prev(k) = m_head
                next
                m_level = level
            end if
            set node = (new tnode).init(data, level, m_nil)
            for k = 0 to level-1
                set node.m_next(k) = prev(k).m_next(k)
                set prev(k).m_next(k) = node
            next
            m_cnt = m_cnt+1
        end if
    end function

    function sldelete(byval data)
        wscript.echo "** Deleting => ", data
        dim k, node, prev() : redim prev(MAXLEVEL-1)
        set node = m_head
        for k = m_level-1 to 0 step -1
            do while node.m_next(k).m_data < data
                set node = node.m_next(k)
            loop
            set prev(k) = node
        next
        set node = node.m_next(0)
        if node.m_data <> data then ' not found
            sldelete = false
        else
            for k = 0 to m_level-1
                if not prev(k).m_next(k) is node then
                    exit for
                end if
                set prev(k).m_next(k) = node.m_next(k)
            next
            do while m_level > 1 and m_head.m_next(m_level-1) is m_nil
                m_level = m_level-1
            loop
            m_cnt = m_cnt-1
            sldelete = true
        end if
    end function

end class

call main
