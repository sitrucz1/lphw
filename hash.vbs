'
' Shows hashing techniques and collision resolution
'

option explicit

sub main()
    dim ht : set ht = (new thashtable).init(7)
    ht.put "email1", "curtis@matzzone.com"
    ht.put "work1", "kelly@matzzone.com"
    ht.put "work2", "curtis.matz@optum.com"
    ht.put "iphone", "curt@matzzone.com"
    ht.put "daughter1", "sara@matzzone.com"
    ht.put "son1", "someone@matzzone.com"
    ht.printtable
    wscript.echo "get"
    wscript.echo ht.get_("iphone").m_data
    wscript.echo ht.get_("son1").m_data
    wscript.echo ht.get_("daughter1").m_data
    wscript.echo "delete"
    wscript.echo ht.delete_("son1").m_data
    wscript.echo ht.delete_("work2").m_data
    wscript.echo ht.delete_("work1").m_data
    wscript.echo ht.delete_("iphone").m_data
    wscript.echo ht.delete_("daughter1").m_data
    ht.printtable

    dim st : set st = new tstack
    st.push "iphone", "curtis@matzzone.com"
    st.push "work", "curtis.matz@optum.com"
    wscript.echo st.count
    wscript.echo st.pop.m_key
    wscript.echo st.pop.m_key
end sub

class titem

    public m_key
    public m_data
    public m_next

    private sub class_initialize
    end sub

    private sub class_terminate
    end sub

    public function init(key, data)
        m_key = key
        m_data = data
        set m_next = nothing
        set init = me
    end function

end class

class thashtable
    public m_list
    public m_size
    public m_cnt
    private m_dummy     ' fake root/head

    private sub class_initialize
    end sub

    private sub class_terminate
    end sub

    public function init(size)
        redim m_list(size-1)
        m_size = size
        m_cnt = 0
        dim i
        for i = 0 to ubound(m_list)
            set m_list(i) = Nothing
        next
        set m_dummy = (new titem).init("dummy", "dummy")
        set init = me
    end function

    private function genhash(key, size)
        dim hash : hash = clng(5381)
        dim i, h
        for i = 1 to len(key)
            hash = ((hash * 33) and &h01ffffff) + asc(mid(key, i, 1))
        next
        genhash = hash mod size
    end function

    public function put(key, data)
        dim idx : idx = genhash(key, m_size)
        dim prev : set prev = m_dummy : set prev.m_next = m_list(idx)
        do while not prev.m_next is nothing
            set prev = prev.m_next
        loop
        set prev.m_next = (new titem).init(key, data)
        set m_list(idx) = m_dummy.m_next
        m_cnt = m_cnt+1
        set put = prev.m_next
    end function

    public function get_(key)
        dim idx : idx = genhash(key, m_size)
        dim curr : set curr = m_list(idx)
        do while not curr is nothing
            if key = curr.m_key then
                exit do
            end if
            set curr = curr.m_next
        loop
        set get_ = curr
    end function

    public function delete_(key)
        dim idx : idx = genhash(key, m_size)
        dim prev : set prev = m_dummy : set prev.m_next = m_list(idx)
        ' Invariant: prev is not nothing (ie at fake root) and prev.m_next points to real root
        ' dummy ==> arr(idx) ==> ... ==> Nothing
        do while not prev.m_next is nothing ' and key <> prev.m_next.m_key
            if key = prev.m_next.m_key then
                exit do
            end if
            set prev = prev.m_next
        loop
        ' two cases (1) not found - prev.m_next is nothing (2) found - prev.m_next is NOT nothing
        if prev.m_next is nothing then
            set delete_ = nothing
            exit function
        end if
        dim temp : set temp = prev.m_next   ' save a pointer to the found key
        set prev.m_next = prev.m_next.m_next
        set m_list(idx) = m_dummy.m_next    ' update root in case it was deleted
        m_cnt = m_cnt-1
        set delete_ = temp
    end function

    public sub printtable()
        dim i
        for i = 0 to ubound(m_list)
            wscript.stdout.write i & " => "
            dim curr : set curr = m_list(i)
            do while not curr is nothing
                wscript.stdout.write curr.m_key & "=>" & curr.m_data & " "
                set curr = curr.m_next
            loop
            wscript.stdout.writeline
        next
        wscript.echo "fill factor => ", m_cnt / m_size * 100
    end sub

end class

class tstack

    public m_top
    public m_cnt

    private sub class_initialize
        set m_top = nothing
        m_cnt = 0
    end sub

    private sub class_terminate
    end sub

    public sub push(key, data)
        dim temp : set temp = m_top
        set m_top = (new titem).init(key, data)
        set m_top.m_next = temp
        m_cnt = m_cnt+1
    end sub

    public function pop()
        dim temp : set temp = m_top
        if not m_top is nothing then
            set m_top = m_top.m_next
        end if
        m_cnt = m_cnt-1
        set pop = temp
    end function

    public function count()
        count = m_cnt
    end function

end class

call main()
