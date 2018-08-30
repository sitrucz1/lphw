option explicit

sub main()
    dim bt : set bt = new tbtree
    ' bt.m_root.m_key(bt.m_root.m_cnt) = 3 : bt.m_root.m_cnt = bt.m_root.m_cnt+1
    ' bt.m_root.m_key(bt.m_root.m_cnt) = 5 : bt.m_root.m_cnt = bt.m_root.m_cnt+1
    bt.btput(3)
    bt.btput(5)
    wscript.echo bt.btfind(7)
end sub

class tnode

    public m_key(2)
    public m_next(3)
    public m_cnt
    public m_leaf

    public sub class_initialize()
        dim k
        for k = 0 to 2
            m_key(k) = -1
        next
        for k = 0 to 3
            set m_next(k) = nothing
        next
        m_cnt = 0
        m_leaf = true
    end sub

end class

class tbtree

    public m_root
    public m_cnt

    public sub class_initialize()
        set m_root = new tnode
        m_cnt = 1
    end sub

    public function btfind(byval v)
        btfind = btfindn(m_root, v)
    end function

    public function btfindn(byval node, byval v)
        dim k
        k = 0
        do while k < node.m_cnt ' and v > node.m_key(k)
            if v > node.m_key(k) then
                k = k+1
            else
                exit do
            end if
        loop
        if node.m_leaf then
            btfindn = -1
            if k < node.m_cnt then
                if node.m_key(k) = v then
                    btfindn = v
                end if
            end if
        else
            btfindn = btfindn(node.m_next(k), v)
        end if
    end function

    public function btput(byval v)
        set m_root = btputn(m_root, v)
    end function

    public function btputn(byval node, byval v)
        dim k
        k = 0
        do while k < node.m_cnt ' and v > node.m_key(k)
            if v > node.m_key(k) then
                k = k+1
            else
                exit do
            end if
        loop
        if node.m_leaf then
            if k < node.m_cnt then
                if node.m_key(k) = v then
                    set btputn = node
                    exit function
                end if
            end if
            dim i
            i = k
            for i = m_cnt-1 to k step -1
                node.m_key(i+1) = node.m_key(i)
            next
            node.m_key(k) = v
            node.m_cnt = node.m_cnt+1
            set btputn = node
        else
            set node.m_next(k) = btputn(node.m_next(k), v)
            ' check for 3 keys and split on the way up the tree
            set btputn = node
        end if
    end function

end class

call main
